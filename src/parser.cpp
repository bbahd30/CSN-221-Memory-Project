#include <iostream>
#include <fstream>
#include <string>
#include <bitset>
#include <vector>

#include "utils.h"

int main(int argc, char** argv){
	if(argc<2) std::cout<<"No file provided to parse"<<std::endl;

	std::string in_file_name = argv[1];
	std::string out_file_name = "m.bin";
	std::ifstream instruction_file(in_file_name);
	std::ofstream binary_file(out_file_name);

	std::vector<std::string> instruction_vector;
	std::string temp_instruction = "";
	while(getline(instruction_file, temp_instruction)){
		instruction_vector.push_back(temp_instruction);
	}

	std::vector<std::string> program;

	for(int i=0; i<instruction_vector.size(); i++){
		std::string inst = instruction_vector[i];
		trim(inst);
		program.push_back(hexToBin(inst));
	} 

	for(int i=0 ; i<program.size(); i++){
		binary_file<<program[i]<<std::endl;
	}

	instruction_file.close();
	binary_file.close();

	std::cout<<"Successfully compiled"<<std::endl;
}

