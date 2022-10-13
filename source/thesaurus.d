module thesaurus;

import misc;
import lists;
import std.file;
import std.random;
import std.conv:to;
import std.algorithm:canFind;

/*
Thesaurus mem:
{
Word
Synonym1
Synonym2
Synonym3
}
{
Word2
Synonym1
Synonym2
Synonym3
}
*/

class Thesaurus{
private:
	List!string wlist;
	string fname;
public:
	this(string f=""){
		wlist = new List!string;
		fname = f;
		if (f!="" && exists(f)){
			wlist.loadArray(fileToArray(f));
		}
	}
	~this(){
		delete wlist;
	}
	void load(string f){
		fname = f;
		wlist.loadArray(fileToArray(f));
	}
	void save(){
		wlist.saveFile(fname,"\n");
	}
	void addWord(string word, string syn){
		bool[2] know;
		word = lowercase(word);
		syn = lowercase(syn);
		know[0] = knows(word);
		know[1] = knows(syn);

		uinteger insPos;
		if (know[0]){
			insPos = wlist.indexOf(word);
			insPos = wlist.indexOf("}",insPos);
			wlist.insert(insPos,[syn]);
		}else if (know[1]){
			insPos = wlist.indexOf(syn);
			insPos = wlist.indexOf("}",insPos);
			wlist.insert(insPos,[word]);
		}else{
			wlist.add("{");
			wlist.add(word);
			wlist.add(syn);
			wlist.add("}");
		}
	}
	bool knows(string s){
		bool r=true;
		if (wlist.indexOf(lowercase(s))==-1){
			r=false;
		}
		return r;
	}
	string getSyn(string word){
		uinteger f, t;
		string[] syns;
		if (knows(word)){
			uinteger wPos = wlist.indexOf(word);
			f = wlist.indexOf("{",wPos,false)+1;
			t = wlist.indexOf("}",wPos,true);
			syns = wlist.readRange(f,t);
		}else{
			syns=[word];
		}
		return syns[getRand(syns.length)];
	}
	string getStandard(string word){
		string r=null;
		integer pos = wlist.indexOf(lowercase(word));
		if (pos>=0){
			if (wlist.read(pos-1)!="{"){
				pos = wlist.indexOf("{",pos,false);
				r = wlist.read(pos+1);
			}else{
				r = word;
			}
		}
		return r;
	}
	bool isSame(string w1,string w2){
		uinteger f, t, w1Pos, w2Pos;
		bool r=false;
		w1Pos = wlist.indexOf(lowercase(w1));
		w2Pos = wlist.indexOf(lowercase(w2));
		if(w1Pos>0 && w2Pos>0){
			f = wlist.indexOf("{",w1Pos,false);
			t = wlist.indexOf("}",w1Pos,true);
			if (w2Pos>f && w2Pos<t){
				r=true;
			}
		}
		return r;
	}
	ubyte getSimilarity(string s1, string s2){
		uinteger iPos, i;
		string[] a1, a2;
		string tmstr;
		uinteger r=0;

		a1 = sentenceToWords(standardize(s1));//no need for lowercase, standardize does that itself
		a2 = sentenceToWords(standardize(s2));

		//get number of similar/same words in `r`
		for (i=0;i<a1.length;i++){
			if (a2.canFind(a1[i])){
				r++;
			}
		}
		//to percentage
		if (r==a1.length/* && a1.length>0*/){
			r=100;
		}else if (r>0){
			r=cast(ubyte)(r*100/a1.length);
			//if `a2` was 3+ words bigger than `a1` && r!=100, decrease `r` by 25%
			if (a2.length>a1.length && a2.length-a1.length>=4){
				if (r<25){
					r=0;
				}else{
					r-=25;
				}
			}
		}
		return cast(ubyte)r;
	}
	string modify(string s){
		string tmstr;
		uinteger i;
		uinteger iPos;
		s = lowercase(s);
		for (i=0;i<s.length;i++){
			if ("., ?!".canFind(s[i])){
				tmstr=prevWord(s,i-1);
				iPos = i-tmstr.length;
				s = strDelete(s,iPos,tmstr.length);
				tmstr = getSyn(tmstr);
				s = strInsert(s,tmstr,iPos);
				i=iPos+tmstr.length;
			}
		}
		return s;
	}
	string standardize(string s){
		string tmstr, rep;
		uinteger i;
		uinteger iPos;
		s = lowercase(s);
		for (i=0;i<s.length;i++){
			if ("., ?!".canFind(s[i])){
				tmstr=prevWord(s,i-1);
				iPos = i-tmstr.length;
				rep = getStandard(tmstr);
				if (rep){
					s = strDelete(s,iPos,tmstr.length);
					tmstr = getStandard(tmstr);
					s = strInsert(s,tmstr,iPos);
					i=iPos+tmstr.length;
				}
			}
		}
		return s;
	}
}
