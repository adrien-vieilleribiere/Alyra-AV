pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0

contract NotesManager {
    mapping(address => uint256[]) notes;
    address[] students;
    enum Etape {
        Todo,
        InProgress,
        Finished
    }
    Etape public defaultstate = Etape.InProgress;

    function addNote(address _student_adress, uint256 _note) public {
        // todo check if the caller has the right to do it
        if (notes[_student_adress].length == 0) {
            students.push(_student_adress);
        }
        notes[_student_adress].push(_note);
    }

    function getStudents() public view returns (address[] memory) {
        // todo check rights
        return students;
    }

    function getStudentNotes(address _student_adress)
        public
        view
        returns (uint256[] memory)
    {
        // todo check rights
        return notes[_student_adress];
    }

    function getStudentAverage(address _student_adress)
        public
        view
        returns (uint256)
    {
        // todo check rights
        uint256 size = notes[_student_adress].length;
        uint256 total = 0;
        for (uint256 i = 0; i < size; i++) {
            total += notes[_student_adress][i];
        }
        // todo : fix approximation (floating resut)
        return total / size;
    }

    function getGlobalAverage() public view returns (uint256) {
        // todo check rights
        uint256 size = students.length;
        uint256 total = 0;
        for (uint256 i = 0; i < size; i++) {
            total += getStudentAverage(students[i]);
        }
        // todo : fix approximation (floating resut)
        return total / size;
    }
}
