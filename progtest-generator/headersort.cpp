#include <iostream>
#include <string>
#include <fstream>
#include <streambuf>
#include <regex>
#include <vector>
#include <unordered_map>
#include <iterator>
#include <tuple>

using namespace std;

class topologicalSort{
public:
    topologicalSort(const vector<vector<int>> &dependencies) : dependencies(dependencies), size(dependencies.size()), state(size, nodeState::fresh) {}

    vector<int> solve(){
        for(int i = 0; i < size; i++){
            dfs(i);
        }
        return result;
    }

private:
    enum class nodeState{
        fresh, open, closed
    };

    void dfs(int index){
        if (state[index] == nodeState::open){
            cerr << "Headers contain circular dependencies - cannot produce topological ordering" << endl;
            exit(1);
        } else if  (state[index] == nodeState::closed){
            return;
        }

        state[index] = nodeState::open;

        for(int edgeTarget : dependencies[index]){
            dfs(edgeTarget);
        }

        state[index] = nodeState::closed;
        result.push_back(index);
    }

    const std::vector<std::vector<int>> &dependencies;
    int size;
    std::vector<nodeState> state;

    std::vector<int> result;
};

//------------------------------------------------

std::tuple<std::string, std::string> separatePathAndName(const std::string &filepath){
    const auto position = filepath.find_last_of("/\\");

    std::string path = filepath.substr(0,position+1);
    std::string filename = filepath.substr(position+1);
    return {path, filename};
}

std::string loadFiletoString(const std::string &filepath){
    using bufIter = std::istreambuf_iterator<char>;
    ifstream t(filepath);
    return std::string((bufIter(t)), bufIter());
}

//----------------------------------------------------

class headerOrdering{
public:
    void solve(){
        loadFilePaths();
        makeDependencies();
        solveAndPrint();
    }

private:
    void loadFilePaths(){
        int counter = 0;
        std::string filepath;

        while(cin >> filepath){
            std::string filename;

            std::tie(path, filename) = separatePathAndName(filepath);
            
            nameMapping[filename] = counter++;
            names.push_back(filename);
        }
        fileCount = names.size();

        dependencies.resize(fileCount);
    }

    void makeDependencies(){
        for(const auto &filename : names){
            const int fromFileIndex = nameMapping.at(filename);
            string fileStr = loadFiletoString(path+filename);

            regex pattern("#include \"(.*)\"");
            smatch matches;
            string::const_iterator searchStart(fileStr.cbegin());

            while(regex_search(searchStart, cend(fileStr), matches, pattern)){
                const std::string headerFileName = matches[1].str();
                int toFileIndex = nameMapping.at(headerFileName);

                dependencies[fromFileIndex].push_back(toFileIndex);

                searchStart += matches.position() + matches.length();
            }
        }
    }

    void solveAndPrint(){
        topologicalSort TS(dependencies);
        std::vector<int> ordering = TS.solve();
        for(int index : ordering){
            cout << (path+names[index]) << endl;
        }
    }

    std::string path;
    int fileCount;
    std::unordered_map<std::string, int> nameMapping;
    std::vector<std::string> names;

    std::vector<std::vector<int>> dependencies;
};

int main(int argc, char const *argv[]){
    headerOrdering ordering;
    ordering.solve();

    return 0;
}