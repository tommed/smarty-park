// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

// import "./Spaces.sol";

contract Cars {

  // Spaces private spaces;
  int16 public constant defaultScore = 100;

  // owner of this contract
  address owner;

  // registration of cars using smarty park
  mapping(string => CarDetails) public cars;

  // reviews need to be separate due to issues of arrays in structs
  mapping(string => Review[]) public allReviews;

  // events
  event CarRegistered(string _regNumber, address _owner);
  event CarDisabledChanged(string _regNumber, bool _disabled);

  // we need a reference to spaces
  constructor() { //address _t) {
    // spaces = Spaces(_t);
    owner = msg.sender;
  }
  modifier _ownerOnly() {
      require(msg.sender == owner);
      _;
  }

  // a positive or negative review creates a score
  // this is held against a car's registration number
  struct Review {
    int16 score;
    uint256 addedAt;
    string reason;
    string spaceId;
    address fromLandlord;
  }

  // the registered details of a user
  struct CarDetails {
    address owner;
    bool disabledByAdmin;
    uint256 addedAt;
    string nickname;
  }

  // perform a new car registration
  function registerCar(string memory _regNumber, string memory _nickname) public {
    CarDetails memory car = cars[_regNumber];
    Review[] storage reviews = allReviews[_regNumber];
    require(bytes(_regNumber).length > 5, 'REG_TOO_SHORT');
    require(bytes(_regNumber).length < 10, 'REG_TOO_LONG');
    require(car.owner == address(0), 'ALREADY_REGISTERED');
    car.addedAt = block.timestamp;
    car.owner = msg.sender;
    car.nickname = _nickname;
    cars[_regNumber] = car;
    // add initial review
    reviews.push(Review(defaultScore, car.addedAt, "REGISTRATION", "", address(0)));
    allReviews[_regNumber] = reviews;
    emit CarRegistered(_regNumber, msg.sender);
  }

  // calculate the car's score
  function getCarScore(string memory _regNumber) public view
    returns (int _totalScore, uint _lastActivity, string memory _lastReason)
    {
    Review[] memory reviews = allReviews[_regNumber];
    require(reviews.length > 0, 'NOT_REGISTERED');
    int score;
    uint lastAddedAt;
    string memory reason = "";
    for (uint i=0; i < reviews.length; i++) {
      score = score + reviews[i].score;
      lastAddedAt = reviews[i].addedAt;
      reason = reviews[i].reason;
    }
    return (score, lastAddedAt, reason);
  }

  // admins can disable/enable a car if they need to
  function setCarDisabled(string memory _regNumber, bool _disabled) public _ownerOnly {
    CarDetails storage car = cars[_regNumber];
    require(car.owner != address(0), 'NOT_REGISTERED');
    car.disabledByAdmin = _disabled;
    cars[_regNumber] = car;
    emit CarDisabledChanged(_regNumber, _disabled);
  }

}