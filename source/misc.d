module misc;

import std.stdio;
import std.file;
import lists;
import std.datetime;
import std.conv:to;
import std.algorithm:canFind;

alias integer = ptrdiff_t;
alias uinteger = size_t;

string[] fileToArray(string fname){
	File f = File(fname,"r");
	string[] r;
	string line;
	integer i=0;
	r.length=0;
	while (!f.eof()){
		if (i+1>=r.length){
			r.length+=5;
		}
		line=f.readln;
		if (line.length>0 && line[line.length-1]=='\n'){
			line.length--;
		}
		r[i]=line;
		i++;
	}
	f.close;
	r.length = i-1;
	return r;
}

void arrayToFile(string[] ar, string fname){
	File f = File(fname,"w");
	for (uinteger i=0;i<ar.length;i++){
		f.writeln(ar[i]);
	}
	f.close;
}

integer searchArray(string[] ar, string s, uinteger start=0, bool forward=true){
	integer i;
	if (forward){
		for (i=start;i<ar.length;i++){
			if (ar[i]==s){break;}
		}
	}else{
		for (i=start;i>0;i--){
			if (ar[i]==s){break;}
		}
	}
	if(i==ar.length){i=-1;}
	return i;
}

string[] insertArray(string[] ar, string s, uinteger ind){
	uinteger i, tod=0;
	string[] res;
	res.length = ar.length+1;
	for (;i<ar.length;i++){
		if (i==ind){
			res[tod]=s;
			tod++;
		}
		res[tod]=ar[i];
		tod++;
	}
	return res;
}

uinteger getRand(uinteger max){
	SysTime currTime = Clock.currTime;
	uinteger tm = currTime.second+(currTime.minute*60)+(currTime.hour*60*60);
	uinteger r;
	if (max>0){
		if (tm>=max){
			r = tm % max;
		}else{
			r = tm;
		}
	}else{
		r = 0;
	}
	return r;
}

string lowercase(string s){
	string tmstr;
	ubyte tmbt;
	for (integer i=0;i<s.length;i++){
		tmbt = cast(ubyte) s[i];
		if (tmbt>=65 && tmbt<=90){
			tmbt+=32;
			tmstr ~= cast(char) tmbt;
		}else{
			tmstr ~= s[i];
		}
	}
	
	return tmstr;
}

bool isAlphabet(string s){
	s = lowercase(s);
	uinteger i;
	bool r=true;
	ubyte chCode;
	for (i=0;i<s.length;i++){
		chCode = cast(ubyte)s[i];
		if (chCode<97 || chCode>122){r=false;break;}
	}
	return r;
}

string nextWord(string s, uinteger start, string ad=""){
	integer i;
	string tmstr;
	string spt;
	spt = "., !?";
	spt~=ad;
	for (i=start;i<s.length;i++){
		if (spt.canFind(s[i])){break;}
		tmstr = tmstr~s[i];
	}
	return tmstr;
}

string reverse(string s){
	integer i;
	string tmstr;
	for (i=s.length-1;i>=0;i--){
		tmstr = tmstr~s[i];
	}
	return tmstr;
}

string prevWord(string s, uinteger start, string ad=""){
	integer i;
	string tmstr;
	string spt;
	spt = "., !?";
	spt~=ad;
	integer tmint;
	for (i=start;i>=0;i--){
		if (spt.canFind(s[i])){break;}
		tmstr = tmstr~s[i];
	}
	tmstr = reverse(tmstr);
	return tmstr;
}

string strInsert(string s, string ins, uinteger pos){
	string[2] tmstr;
	tmstr[0] = s[0..pos];
	tmstr[1] = s[pos..s.length];
	return tmstr[0]~ins~tmstr[1];
}

string strDelete(string s, integer from, integer count){
	string[2] tmstr;
	tmstr[0] = s[0..from];
	tmstr[1] = s[from+count..s.length];
	return tmstr[0]~tmstr[1];
}

string[] sentenceToWords(string s){
	string[] r;
	string tmstr;
	List!string list = new List!string;
	for (uinteger i=0;i<s.length;i++){
		if ("., ?!'\t".canFind(s[i])){
			tmstr=prevWord(s,i-1);
			if (tmstr!=""){
				list.add(tmstr);
			}
		}
	}
	r = list.toArray;
	.destroy(list);
	return r;
}
