module main;

import bot;
import misc;
import std.path;
import thesaurus;
import std.stdio;
import core.thread;
import std.concurrency;

const AUTHOR = "Nafees Hassan"; 
const VERSION = "0.0.1";

void main(string[] args){
	string currDir = dirName(args[0]);
	QBot bot = new QBot(currDir~"/mem",currDir~"/thesmem");

	writeln("qAI version ",VERSION," Created by ",AUTHOR);
	writeln("Press CTRL+C at any time to quit.");
	write("Enter c to enter chat mode, l to enter learn mode:");
	string input = readln();
	input.length--;
	if (input=="c"){
		while (true){
			write("you: ");
			input = readln();
			input.length--;
			write("qAI: ");
			writeln(bot.getAns(input));
		}
	}else if (input=="l"){
		writeln("Enter s to add synonyms/new words, l to add conversations:");
		input = readln;
		input.length--;
		if (input=="s"){
			string s;
			while (true){
				write("word   : ");
				input = readln;
				input.length--;
				s = input;
				write("synonym: ");
				input = readln;
				input.length--;
				bot.learnSyn(s,input);
			}
		}else if (input=="l"){
			string s;
			while (true){
				write("asked: ");
				input = readln;
				input.length--;
				s = input;
				write("reply: ");
				input = readln;
				input.length--;
				bot.learn(s,input);
			}
		}
	}
	delete bot;
	write("\nExiting qAI, press Enter...");readln;
}

