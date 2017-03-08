module sentence;

import misc;
import lists;
import thesaurus;
import std.algorithm:canFind;

class Tsentence{
private:
	string line;
	string[] words;
	uint pos;
public:
	this(string s=null){
		if (line){
			this.loadline(s);
		}
	}
	void loadline(string s){
		Tlist!string wrds = new Tlist!string;
		line = s;

		string sp = "! ,?.";
		uint i, rFrom;
		uint end = s.length-1;
		for (i=0;i<s.length;i++){
			if (sp.canFind(s[i]) || i==end){
				wrds.add(sp[rFrom..i]);
				wrds.add(to!string(sp[i]));
				rFrom++;
			}else{
				rFrom++;
			}
		}
		words = wrds.toArray;
		delete wrds;
	}
	string read(){
		string r;
		if (pos<words.length){
			r = words[pos];
			pos++;
		}else{
			r=null;
		}
		return r;
	}
	void modify(Thesaurus thes){
		this.loadline(thes.modify(line));
	}
	string standardize(){

	}
	@property position(uint i){
		return pos=i;
	}
	@property position(){
		return pos;
	}
	@property totalWords(){
		return words.length;
	}
	@property sentence(){
		return line;
	}
}