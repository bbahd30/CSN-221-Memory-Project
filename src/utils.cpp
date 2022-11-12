#include <string>
#include <vector>
#include "utils.h"

// For Trim
#include <algorithm> 
#include <cctype>
#include <locale>

void trim(std::string &str){
    
    
    str.erase(str.begin(), std::find_if(str.begin(), str.end(), [](unsigned char ch) {
        return !std::isspace(ch);
    }));
    

    str.erase(std::find_if(str.rbegin(), str.rend(), [](unsigned char ch) {
        return !std::isspace(ch);
    }).base(), str.end());
    

}

// std::vector<std::string> split(std::string str, char ch){
//     trim(str);
//     std::vector<std::string> splitted_str;
//     std::string s="";
//     int i=0;
//     while(i < str.length()){
//         if (str[i] == ch)
//         {
//             trim(s); 
//             splitted_str.push_back(s);
//             s = "";
//         }
//         else if (str[i]!=ch)
//         {
//             s += str[i];
//         }
//         i++;
//     }
//     trim(s);
//     splitted_str.push_back(s);
//     return splitted_str;
// }

// unsigned short parse_register_string (std::string register_string) {
//      return (unsigned short)std::stoul(register_string.substr(1,register_string.length()-1));
// }

