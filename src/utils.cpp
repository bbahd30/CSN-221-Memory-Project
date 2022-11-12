#include <string>
#include <vector>
#include "utils.h"

// For Trim
#include <algorithm> 
#include <cctype>
#include <locale>

std::string hexToBin(std::string s){
    std::string inst = "";
    char c;
    for(int i=0 ; i<7 ; i++){
        c = s[i];
        switch (c) {
            case '0':
                inst.append("0000");
                break;
            case '1':
                inst.append("0001");
                break;
            case '2':
                inst.append("0010");
                break;
            case '3':
                inst.append("0011");
                break;
            case '4':
                inst.append("0100");
                break;
            case '5':
                inst.append("0101");
                break;
            case '6':
                inst.append("0110");
                break;
            case '7':
                inst.append("0111");
                break;
            case '8':
                inst.append("1000");
                break;
            case '9':
                inst.append("1001");
                break;
            case 'a':
                inst.append("1010");
                break;
            case 'b':
                inst.append("1011");
                break;
            case 'c':
                inst.append("1100");
                break;
            case 'd':
                inst.append("1101");
                break;
            case 'e':
                inst.append("1110");
                break;
            case 'f':
                inst.append("1111");
                break;
            default:
                break;
        }
    }
    return inst;
} 

void trim(std::string &str){
    
    
    str.erase(str.begin(), std::find_if(str.begin(), str.end(), [](unsigned char ch) {
        return !std::isspace(ch);
    }));
    

    str.erase(std::find_if(str.rbegin(), str.rend(), [](unsigned char ch) {
        return !std::isspace(ch);
    }).base(), str.end());
    

}