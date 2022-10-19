// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import "./Spaces.sol";
import "./Cars.sol";

contract Parking {

  // instances to access APIs
  Spaces spaceRepo;
  Cars carRepo;

  // events
  event SuccessfulTransaction(address from, address to, string space, string car, uint256 timestamp);

  // contract state
  mapping(string => bool) public spacesInUse;
  mapping(string => ParkingInfo) public carsParked;

  // our parking info
  struct ParkingInfo {
    string space;
    address paymentRecipient;
    uint256 startedAt;
    uint pricePerMinute;
  }

  // ctor
  constructor(address spacesAddr, address carsAddr) {
    spaceRepo = Spaces(spacesAddr);
    carRepo = Cars(carsAddr);
  }

  // begin a parking session
  // TODO: ensure user has agreed to the rules via signature?
  function startParkingSession(string memory _carId, string memory _spaceId) public {
    Cars.CarDetails memory car = carRepo.getCar(_carId);
    Spaces.ParkingSpace memory space = spaceRepo.getSpace(_spaceId);
    ParkingInfo memory session = carsParked[_carId];
    require(car.owner != address(0), 'CAR_NOT_FOUND');
    require(car.disabledByAdmin == false, 'CAR_DISABLED');
    require(session.startedAt == 0, 'CAR_ALREADY_PARKED');
    require(space.enabled == true, 'SPACE_DISABLED');
    require(space.verified == true, 'SPACE_NOT_VERIFIED');
    session.space = _spaceId;
    session.startedAt = block.timestamp;
    session.pricePerMinute = space.pricePerMinute;
    session.paymentRecipient = space.landlord;
    carsParked[_carId] = session;
    spacesInUse[_spaceId] = true;
  }

  function costForParking(string memory _carId, uint256 atTime) public view returns (uint, ParkingInfo memory) {
    ParkingInfo memory session = carsParked[_carId];
    require(session.startedAt != 0, 'PARKING_SESSION_NOT_FOUND');
    uint parkedForSeconds = atTime - session.startedAt;
    uint parkedForMins = parkedForSeconds / 60.0;
    uint priceForParking = session.pricePerMinute * parkedForMins;
    return (priceForParking, session);
  }

  function completeParking(string memory _carId) public payable {
    // calculate cost of parking
    uint timeNow = block.timestamp;
    (uint priceForParking, ParkingInfo memory session) = costForParking(_carId, timeNow);
    require(msg.value >= priceForParking, 'NOT_ENOUGH_PAYMENT');
    // make payment
    (bool success, ) = session.paymentRecipient.call{value:priceForParking}("");
    require(success, "TRANSACTION_FAILED");
    delete carsParked[_carId];
    delete spacesInUse[session.space];
    // emit event
    emit SuccessfulTransaction(msg.sender, session.paymentRecipient, session.space, _carId, timeNow);
    // TODO: we don't have a method yet for deploying our 'first reward' ERC1155 token :(
  }

}