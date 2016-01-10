
#ifndef LIB_H
  #include "libh.lsl"
#endif

debugSay(string msg)
{
   if (debug)
      llOwnerSay(msg);
   //llSay(MY_DEBUG_CHAN,msg);
}


setGlow(integer prim, float  amount)
{
    llSetLinkPrimitiveParamsFast(prim,[PRIM_GLOW,ALL_SIDES,amount]);
}

setFullbright(integer prim, integer on)
{
    llSetLinkPrimitiveParamsFast(prim,[PRIM_FULLBRIGHT,ALL_SIDES,on]);
}

setColor(integer prim, vector c, float alpha)
{
   llSetLinkPrimitiveParamsFast(prim,[PRIM_COLOR,ALL_SIDES,c,alpha]);
}

integer sameOwner(key id)
{
if (id == llGetOwner())
  return TRUE;
else if (llGetOwnerKey(id) == llGetOwner())
  return TRUE;
else 
  return FALSE;  
}

integer randomChan()
{
   return (integer)(llFrand(-1000000000.0) - 1000000000.0);
}

repeatSound(key sound, float volume)
{
    llRegionSay(SOUND_REPEAT_CHAN, (string)sound + ":" + (string)volume);
}

integer objectDescToInt()
{
   return (integer)llList2String(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC ]), 0);
}  

setObjectDesc(string s)
{ //there is a good reason not to use llSetLinkPrimitiveParamsFast here
    llSetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC,s]);
}
	
playInventorySound()
{
   llPlaySound(llGetInventoryName(INVENTORY_SOUND,0),1);
}

string getInventoryTexture()
{
    return llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,0));
}


string getNotecardName(string d)
{
  string s = d;
  if (s == "")
       s = llGetInventoryName(INVENTORY_NOTECARD,0);
  //llOwnerSay("looking for notecard <" + s + ">");   
  if (llGetInventoryType(s) == INVENTORY_NONE)
      {
        llOwnerSay("notecard '" + d + "' not found");
        s = "";
      } 
  return s;    
}

integer getChatChan(list notecardList)
{
   integer n = 0;
   integer ptr = llListFindList(notecardList,["channel"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return n;
}

integer getMenuMode(list notecardList)
{
   integer n = -1;
   integer ptr = llListFindList(notecardList,["menu"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return n;
}

integer getexplodeOnCollision(list notecardList)
{
   integer n = 0;
   integer ptr = llListFindList(notecardList,["collision"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return n;
}

integer getAccess(list notecardList)
{
   integer n = ACCESS_PUBLIC;
   integer ptr = llListFindList(notecardList,["access"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return n;
}

float getVolume(list notecardList)
{
    float f = 1.0;
    integer ptr = llListFindList(notecardList,["volume"]);
    if (ptr > -1)
        f = llList2Float(notecardList,ptr+1);
    return f;
}

float getSpeed(list notecardList)
{
    #define DEFAULT_SPEED 20.0;
    float f = DEFAULT_SPEED;
    integer ptr = llListFindList(notecardList,["speed"]);
    if (ptr > -1)
        f = llList2Float(notecardList,ptr+1);
    return f;
}

float getDelay(list notecardList)
{
    #define DEFAULT_DELAY 20.0;
    float f = DEFAULT_DELAY;
    integer ptr = llListFindList(notecardList,["delay"]);
    if (ptr > -1)
        f = llList2Float(notecardList,ptr+1);
    return f;
}

integer getFlightTime()
{
    #define DEFAULT_TIME 3;
    integer f = DEFAULT_TIME;
    integer ptr = llListFindList(notecardList,["flighttime"]);
    if (ptr > -1)
        f = llList2Integer(notecardList,ptr+1);
    return f;
}

integer getBouyancy()
{
    #define DEFAULT_BOUY 5;
    integer f = DEFAULT_BOUY;
    integer ptr = llListFindList(notecardList,["bouyancy"]);
    if (ptr > -1)
        f = llList2Integer(notecardList,ptr+1);
    return f;
}

integer getPitch()
{
    #define DEFAULT_PITCH 0;
    integer f = DEFAULT_PITCH;
    integer ptr = llListFindList(notecardList,["pitch"]);
    if (ptr > -1)
        f = llList2Integer(notecardList,ptr+1);
    return f;
}

integer getLinkWithName(string name) {
    integer i = llGetLinkNumber() != 0;   // Start at zero (single prim) or 1 (two or more prims)
    integer x = llGetNumberOfPrims() + i; // [0, 1) or [1, llGetNumberOfPrims()]
    for (; i < x; ++i)
        if (llGetLinkName(i) == name)
        {
            return i; // Found it! Exit loop early with result
         }
    return -1; // No prim with that name, return -1.
}

list getLinknumberList()
    {
	linknumberList = [];
    integer i = llGetLinkNumber() != 0;   // Start at zero (single prim) or 1 (two or more prims)
    integer x = llGetNumberOfPrims() + i; // [0, 1) or [1, llGetNumberOfPrims()]
    for (; i < x; ++i)
    {
         linknumberList = linknumberList + llGetLinkName(i) + i;
    }
    return linknumberList;
}

integer getLinknumber(string name)
{
    integer n;
    integer ptr = llListFindList(linknumberList,(list)name);
    if (ptr > -1)
        n = llList2Integer(linknumberList,ptr+1);
    return n;
}

list getLinknumbers(list names)
{
    integer i;
    list foo;
    integer len = llGetListLength( names);
    for (i=0; i<len;i++)
    {
        foo = foo + getLinknumber(llList2String(names,i));
    }
    return foo;
}

/*
list mergeLists(list newList, list oldList)
{
  integer length;
  list keyword;
  list value;
  integer ptr;
  integer i;
  list subList;      
  length = llGetListLength(newList);  
  for (i=0; i<length; i=i+2)
  {
      subList = llList2List(newList,i,i+1);
      subList = list_cast(subList);
      // llSay(0, llList2CSV(subList));
      keyword = llList2List(subList,0,0); 
      value = llList2List(subList,1,1);  

      //llSay(0, llList2CSV(key1));
      ptr = llListFindList(oldList,keyword);  //case sensitive, unfortunately
      //if (ptr != -1)//llSay(0,(string)ptr);
      oldList = llListReplaceList(oldList,subList,ptr, ptr+1);
   }
   return oldList;
}
   
//This function typecasts a list of strings, into the types they appear to be. 
//Extremely useful for feeding user data into llSetPrimitiveParams
//It takes a list as an input, and returns that list, with all elements correctly typecast, as output
//Written by Fractured Crystal, 27 Jan 2010, Commissioned by WarKirby Magojiro, this function is Public Domain
list list_cast(list in)
{
    list out;
    integer i = 0;
    integer l= llGetListLength(in);
    while(i < l)
    {
        string d= llStringTrim(llList2String(in,i),STRING_TRIM);
        if(d == "")
	    out += "";
        else
        {
            if(llGetSubString(d,0,0) == "<")
            {
                if(llGetSubString(d,-1,-1) == ">")
                {
                    list s = llParseString2List(d,[","],[]);
                    integer sl= llGetListLength(s);
                    if(sl == 3)
                    {
                        out += (vector)d;
                        //jump end;
                    }else if(sl == 4)
                    {
                        out += (rotation)d;
                        //jump end;
                    }
                }
                //either malformed,or identified
                jump end;
            }
            if(llSubStringIndex(d,".") != -1)
            {
                out += (float)d;
            }
			else
            {
                integer lold = (integer)d;
                if((string)lold == d)
				    out += lold;
                else
                {
                    key kold = (key)d;
                    if(kold)out += [kold];
                    else out += [d];
                }
            }
        }
        @end;
        i += 1;
    }
 
    return out;   
 } 
*/ 


