module memory;

import thesaurus;
import std.file;
import lists;
import misc;

class QMem{
private:
	List!string mem;
	string mFile=null;
	//processed mem:
	string[][string] pMem;
public:
	this(string memFile){
		mFile = memFile;
		mem = new List!string;
		if (exists(memFile)){
			load;
		}
	}
	~this(){
		.destroy(mem);
	}
	void load(){
		//first, load it in mem
		mem.loadArray(fileToArray(mFile));
		//then process it!
		uinteger i, till = mem.length;
		string responsesFor = null, curLine;
		List!string responses = new List!string;
		for (i=0; i<till; i++){
			curLine = mem.read(i);
			if (curLine=="{"){
				responsesFor = mem.read(i-1);
				continue;
			}
			if (responsesFor){
				if (curLine=="}"){
					pMem[responsesFor] = responses.toArray;
					responses.clear;
					responsesFor = null;
					continue;
				}else{
					responses.add(curLine);
				}
			}
		}
		.destroy(responses);
		//everything's set up!
	}
	string getResponse(string asked, Thesaurus* thes){
		//select best match in pMem for `asked`
		uinteger i;
		ubyte lastBest=0, curBest=0;
		string[] responses;

		foreach(elem; pMem.keys){
			curBest = (*thes).getSimilarity(asked, elem);
			if (curBest>lastBest){
				lastBest = curBest;
				responses = pMem[elem];
			}
		}
		if (lastBest==0){
			responses = ["i have no idea how to respond to that!"];
		}
		//now choose a random response
		return responses[getRand(responses.length)];
	}
	void learn(string asked, string resp){
		//check if entry already exists
		if (asked in pMem){
			//increase length, and add this one
			pMem[asked] = pMem[asked]~[resp];
		}else{
			pMem[asked] = [resp];
		}
		//convert to raw format for later usge
		mem.clear;
		for(uinteger i=0; i<pMem.keys.length; i++){
			mem.addArray([pMem.keys[i],"{"]~pMem[pMem.keys[i]]~["}"]);
		}
	}
	void save(){
		mem.saveFile(mFile,"\n");
	}
}
