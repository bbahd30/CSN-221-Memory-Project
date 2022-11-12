#include <iostream>
#include <fstream>
#include <string>
#include <bitset>
#include <vector>

// #include "instruction.h"
#include "utils.h"

// std::unordered_map<std::string, unsigned int> LABEL_MAP;

// int main(int argc, char** argv){
// 	if(argc<2) std::cout<<"No file provided to parse"<<std::endl;

// 	std::string in_file_name = argv[1];
// 	std::string out_file_name = "m.bin";
// 	std::ifstream instruction_file(in_file_name);
// 	std::ofstream binary_file(out_file_name);

// 	std::vector<std::string> instruction_vector;
// 	std::string temp_instruction = "";
// 	while(getline(instruction_file, temp_instruction)){
// 		instruction_vector.push_back(temp_instruction);
// 	}

// 	std::vector<Instruction *> program;
// 	unsigned int counter = 0;
// 	for(unsigned int i=0; i<instruction_vector.size(); ++i){
// 		std::string inst_str = instruction_vector[i];
// 		trim(inst_str);
// 		bool is_label = inst_str[inst_str.length()-1]==':';
// 		if(is_label){
// 			std::string label = inst_str.substr(0, inst_str.length()-1);
// 			LABEL_MAP[label] = counter*4;
// 		}
// 		else{
// 			program.push_back(Instruction::find_class_and_parse(inst_str));
// 			++counter;
// 		}
// 	}

// 	for(Instruction* inst: program){
// 		binary_file<<std::bitset<32>(inst->parse())<<std::endl;
// 	}

// 	instruction_file.close();
// 	binary_file.close();

// 	std::cout<<"Successfully compiled"<<std::endl;
// }

