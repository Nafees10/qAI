module main;

import bot;
import misc;
import thesaurus;

import std.path;
import std.stdio;
import std.string;

const VERSION = "1.0.0";

void main(string[] args){
	string currDir = dirName(args[0]);
	QBot bot = new QBot(currDir~"/mem",currDir~"/thesmem");

	writeln("qAI version ",VERSION);
	writeln("Enter an empty line or Ctrl+D to quit.");
	write("Enter c to enter chat mode, l to enter learn mode:");
	string input = readln().chomp("\n");

	if (input == "c"){
		while (true){
			write("you: ");
			input = readln().chomp("\n");
			if (!input.length)
				break;
			write("qAI: ");
			writeln(bot.getAns(input));
		}
	}else if (input == "l"){
		writeln("Enter s to add synonyms/new words, l to add conversations:");
		input = readln.chomp("\n");

		if (input == "s"){
			string prev;
			while (true){
				write("word   : ");
				input = readln.chomp("\n");
				prev = input;
				write("synonym: ");
				input = readln.chomp("\n");

				if (!prev.length || !input.length)
					break;
				bot.learnSyn(prev,input);
			}
		}else if (input=="l"){
			string prev;
			while (true){
				write("asked: ");
				input = readln.chomp("\n");
				prev = input;
				write("reply: ");
				input = readln.chomp("\n");

				if (!prev.length || !input.length)
					break;
				bot.learn(prev,input);
			}
		}
	}
	write("\nExiting qAI..");
	.destroy(bot);
}

