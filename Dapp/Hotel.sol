pragma solidity ^0.8.4;

contract Hotel {
    
    enum Statuses { Vacant, Occupied }
    Statuses public currentStatus;
    address payable public owner;

    event Occupy(address _occupant, uint _value);
     event Msg(string msg);

    constructor()  {
        owner = payable(msg.sender);
        currentStatus = Statuses.Vacant;
    }

    modifier onlyWhileVacant {
        require(currentStatus == Statuses.Vacant, "Currently occupied.");
        _;
    }

    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Not enough Ether provided.");
        _;
    }
    
    function chkStatus() public view returns (Statuses) {
        return currentStatus;
    }
    
    receive() external payable onlyWhileVacant costs(0.5 ether) {
        currentStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);
    }
    
    function cleanRoom() public payable  {
        require(msg.sender == owner);
        currentStatus = Statuses.Vacant;
        emit Msg("Room-Cleaned");
    }
}