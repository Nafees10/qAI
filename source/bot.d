module bot;

import misc;
import lists;
import memory;
import std.file;
import thesaurus;
import std.algorithm:canFind;

/*Bot mem
user-to-bot
{
all possible responses here
}
...
...
*/

class QBot{
private:
	Thesaurus thes;
	QMem mem;
	string lastAns=null;
public:
	this(string memFile, string thesFile){
		mem = new QMem(memFile);
		thes = new Thesaurus(thesFile);
	}
	~this(){
		thes.save;
		.destroy(thes);
		mem.save;
		.destroy(mem);
	}
	void save(){
		mem.save;
		thes.save;
	}
	void learn(string asked, string resp){
		asked = thes.standardize(asked);
		resp = thes.standardize(resp);
		mem.learn(asked,resp);
	}
	string getAns(string asked, bool learnFromAns=true){
		string r = mem.getResponse(asked,&thes);
		//Add response to memory to learn, if true
		if (learnFromAns && lastAns){
			learn(lastAns,asked);
		}

		lastAns = thes.standardize(r);
		r = thes.modify(r);
		return r;
	}
	void learnSyn(string w1, string w2){
		thes.addWord(w1,w2);
	}
}
