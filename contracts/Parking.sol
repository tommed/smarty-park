// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import "./Spaces.sol";
import "./Cars.sol";

contract Parking {

  // instances to access APIs
  Spaces spaceRepo;
  Cars carRepo;
  address owner;

  // how much the owner gets for service use
  uint public serviceTaxOnParking = 8674167106557; // 865454873589090 wei ~= £1 • 8674167106557 wei ~= £0.01

  // events
  event SuccessfulTransaction(address from, address to, string space, string car, uint256 timestamp);
  event ServiceTaxChanged(uint from, uint to);

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
    owner = msg.sender;
  }
  modifier _ownerOnly() {
      require(msg.sender == owner);
      _;
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
    require(space.landlord != car.owner, 'CANT_PAY_YOURSELF');
    session.space = _spaceId;
    session.startedAt = block.timestamp;
    session.pricePerMinute = space.pricePerMinute;
    session.paymentRecipient = space.landlord;
    carsParked[_carId] = session;
    spacesInUse[_spaceId] = true;
  }

  function costForParking(string memory _carId, uint atTime) public view returns (uint, ParkingInfo memory) {
    ParkingInfo memory session = carsParked[_carId];
    require(session.startedAt != 0, 'PARKING_SESSION_NOT_FOUND');
    uint parkedForSeconds = atTime - session.startedAt;
    uint parkedForMins = parkedForSeconds / 60.0;
    uint priceForParking = session.pricePerMinute * parkedForMins;
    uint priceForParkingPlusServiceTax = priceForParking + serviceTaxOnParking;
    return (priceForParkingPlusServiceTax, session);
  }

  // TODO: we don't have a method yet for deploying our 'first reward' ERC1155 token :(
  function completeParking(string memory _carId) public payable {
    // calculate cost of parking
    uint timeNow = block.timestamp;
    (uint priceForParking, ParkingInfo memory session) = costForParking(_carId, timeNow);
    require(msg.value >= priceForParking, 'NOT_ENOUGH_PAYMENT');
    require(msg.value < (priceForParking * 2), 'WAY_TOO_MUCH_PAYMENT'); // prevent wei/eth mix-ups!

    // make payments
    uint serviceTax = serviceTaxOnParking;
    uint moneyToLandlord = msg.value - serviceTax;
    (bool success, ) = payable(owner).call{ value: serviceTax }("");
    require(success, "SERVICE_TAX_TRANSACTION_FAILED");
    (success, ) = payable(session.paymentRecipient).call{ value: moneyToLandlord }("");
    require(success, "LANDLORD_TRANSACTION_FAILED");

    // remove car parked
    delete carsParked[_carId];
    delete spacesInUse[session.space];

    // emit event
    emit SuccessfulTransaction(msg.sender, session.paymentRecipient, session.space, _carId, timeNow);
  }

  // owner can change the service tax on parking
  function changeServiceTaxOnParking(uint serviceTaxInWei) public _ownerOnly {
    uint oldValue = serviceTaxOnParking;
    serviceTaxOnParking = serviceTaxInWei;
    emit ServiceTaxChanged(oldValue, serviceTaxOnParking);
  }

}