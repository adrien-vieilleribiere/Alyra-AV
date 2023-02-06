pragma solidity 0.8.18 ;
// SPDX-License-Identifier: GPL-3.0

contract People {
    
    struct Person {
        string name;    
        uint age; 
        // string[5] fixedSizeArrayOf5strings 
        // uint[] dynamicArrayOfUints
    }

    Person public moi;

    Person[] public persons;
    // can use persons.length 
    // et si dynamique: persons.push(newPerson), persons.pop();

    mapping (address => uint) exampleBalancesMapping;
    // updated with exampleBalancesMapping["0x..."]=42;

    function modifyPerson (string memory _name, uint _age) public {
        moi.name = _name;
        moi.age = _age;
        // qui equivaut à 
        // moi = Person(_name, _age);
    } 

    function getMyName() public view returns (string memory) {
            return moi.name;
    }

    function getMyAge() public view returns (uint) {
            return moi.age;
    }

    function add(string memory _name, uint _age) public {
        persons.push(Person(_name, _age));
    } 

    function remove() public {
        persons.pop();
    }


   
}