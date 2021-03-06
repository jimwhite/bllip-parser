/*
 * Copyright 1999 Brown University, Providence, RI.
 * 
 *                         All Rights Reserved
 * 
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose other than its incorporation into a
 * commercial product is hereby granted without fee, provided that the
 * above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of Brown University not be used in
 * advertising or publicity pertaining to distribution of the software
 * without specific, written prior permission.
 * 
 * BROWN UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY
 * PARTICULAR PURPOSE.  IN NO EVENT SHALL BROWN UNIVERSITY BE LIABLE FOR
 * ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "auxify.h"
#include <iostream>
#include "Term.h"
#include "ECString.h"
#include "string.h"

char* 	suffixes[] = {
"'VE",
"'M",
"'LL",
"'D",
"'S",
"'RE",
0
};

char* 	auxgs[] = {
"BEIN",
"HAVING",
"BEING",
0
};


char* 	auxs[] = {
"MAHT",
"SHULD",
"WILL",
"WAS",
"OUGHTA",
"AHM",
"NEED",
"MAYE",
"WILLYA",
"WHADDYA",
"HATH",
"HAVE",
"WERE",
"IS",
"HAS",
"MUST",
"DID",
"HAD",
"DO",
"MIGHT",
"WOULD",
"SHALL",
"SHOULD",
"OUGHT",
"COULD",
"DOES",
"HAFTA",
"BE",
"KIN",
"CAN",
"ART",
"BEEN",
"DONE",
"ARE",
"DOO",
"MAY",
"AM",
0
};

bool
hasAuxSuf( ECString word )
{
    size_t pos = word.find_first_of("\'");
    if(pos == -1) return false;
    ECString apostrophe = word.substr(pos, word.length()-pos);
    for( int i = 0; suffixes[i]; i++)
    {
	if( apostrophe == suffixes[i] ) 
	    return true;
    }
    return false;
}

bool
isAux( ECString word )
{
    for( int i = 0; auxs[i]; i++)
    {
	if( word == auxs[i] )
	    return true;
    }
    return false;
}

bool
isAuxg( ECString word )
{
    for( int i = 0; auxgs[i]; i++)
    {
	if( word == auxgs[i] ) 
	    return true;
    }
    return false;
}

char* verbs[] = {
"VB",
"VBD",
"VBG",
"VBN",
"VBP",
"VBZ",
0
};

bool
isVerb( ECString tag )
{
    for( int i = 0; verbs[i]; i++)
	if( tag == verbs[i] ) 
	    return true;
    return false;
}

char*
toUpper(const char* str, char* temp)
{
  int l = strlen(str);
  assert(l < 128);
  for(int i = 0 ; i <= l ; i++)
    {
      char n = str[i];
      int ni = (int)n;
      if(ni >= 97 && ni <= 122)
	{
	  temp[i] = (char)(ni-32);
	}
      else temp[i] = n;
    }
  return temp;
}

ECString
auxify(ECString wM, ECString trmM)
{
  char temp[128];
  ECString w = toUpper(wM.c_str(),temp);
  ECString trm = toUpper(trmM.c_str(),temp);
  if( isVerb( trm ) )
    {
      //cout << "saw verb " << trm << " " << wM << endl;
      if( isAux( w ) || hasAuxSuf( w ) )
	{
	  //cout << "was aux " << w << endl;
	  return "AUX";
	}
      else if( isAuxg( w ) )
	{
	  //cout << "was auxg " << w << endl;
	  return "AUXG";
	}
    }
  return trmM;
}

void
treeauxify(InputTree* tree){
  if(tree->term() != "VP") return;
  InputTreesIter iti = tree->subTrees().begin();
  bool sawVP = false;
  for( ; iti != tree->subTrees().end() ; iti++)
    {
      InputTree* subtree = (*iti);
      ECString subtrmS = subtree->term();
      ConstTerm* subtrm = Term::get(subtrmS);
      if(subtrmS == "VP")
	{
	  sawVP = true;
	  continue;
	}
      else if(subtrm->terminal_p() == 2 || isVerb(subtrmS) ||
	      subtrmS == "ADVP" || subtrmS == "RB" ||
	      subtrmS == "UCP")
	continue;
      else return;
    }
  if(!sawVP) return;
  iti = tree->subTrees().begin();
  for( ; iti != tree->subTrees().end() ; iti++)
    {
      InputTree* subtree = (*iti);
      ECString subtrmS = subtree->term();
      if(subtree->word().empty()) continue;
      ECString newv = auxify(subtree->word(), subtree->term());
      subtree->term() = newv;
    }
  return;
}

				    

	 
