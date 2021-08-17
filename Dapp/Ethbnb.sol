pragma solidity ^0.5.0;

contract EthBnb {
    

    address payable landlordAddress;
    address payable tenantAddress;
    
    struct Flat {
        uint256 price;
        address currentOccupant;
        bool flatIsAvailable;
        uint256 periods;
    }

    Flat[8] flatDB;
    
    event period(uint _periods);

    modifier landlordOnly() {
        require(msg.sender == landlordAddress);
        _;
    }
    
    constructor() public {
        
        landlordAddress = msg.sender;
        
        for (uint i=0; i<8; i++) {
            flatDB[i].flatIsAvailable = true;
            if (i % 2 == 0) {
                flatDB[i].price = 0.2 ether;
            } else {
                flatDB[i].price = 0.5 ether;
            }
        }
    }
    
    
    function getFlatAvailability(uint _flat) view public returns(bool) {
        return flatDB[_flat].flatIsAvailable;
    }

    function getPriceOfFlat(uint _flat) view public returns(uint256) {
        return flatDB[_flat].price;
    }

    function getCurrentOccupant(uint _flat) view public returns(address) {
        return flatDB[_flat].currentOccupant;
    }



    function setFlatAvailability(uint8 _flat, bool _newAvailability) landlordOnly public {
        flatDB[_flat].flatIsAvailable = _newAvailability;
        if (_newAvailability) {
            flatDB[_flat].currentOccupant = address(0);
            flatDB[_flat].periods = 0;
        }
    }
    
    function setPriceOfFlat(uint8 _flat, uint256 _price) landlordOnly public {
        flatDB[_flat].price = _price; 
    }
    


    function rentAFlat(uint8 _flat) public payable returns(uint256) {

        tenantAddress = msg.sender;

        if (msg.value % flatDB[_flat].price == 0 && msg.value > 0 && flatDB[_flat].flatIsAvailable == true) {

            uint256 numberOfNightsPaid = msg.value / flatDB[_flat].price;

            flatDB[_flat].flatIsAvailable = false;

            flatDB[_flat].currentOccupant = tenantAddress;
            
            flatDB[_flat].periods = numberOfNightsPaid;

            landlordAddress.transfer(msg.value);
            
            emit period(numberOfNightsPaid); 
            
            return numberOfNightsPaid;
            
        
        } else {
            
            tenantAddress.transfer(msg.value);
            
            return 0;
        }
        
    }   

}