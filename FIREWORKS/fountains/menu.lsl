////////////////////////
//fireworks menu v1.0
//copyright Tracer Tech aka Tracer Ping 2014
/////////////////////////////
list buttonsOwner=["fire","hide","show"];
//list buttonsGroup=["hide","show","fire"];
//list buttonsPublic=["fire"];
key owner;
key toucher;
integer handle;
integer menuChan;
integer access;
integer chatChan;
integer timeout = 10;

#include "lib.lsl"
 
default
{
   on_rez(integer n){llResetScript();}

   state_entry()
   {
      menuChan = randomChan();
      owner=llGetOwner();
      access = ACCESS_PUBLIC;
   }

   touch_start(integer num)
   {
      string menuText = "on channel " + (string)chatChan + "\n\nChoose One:";
      toucher=llDetectedKey(0);
      llDialog(toucher,menuText,buttonsOwner,menuChan);
      handle=llListen(menuChan,"",toucher,"");
      llSetTimerEvent(timeout); 
   }

   timer()
   {
       llSetTimerEvent(0);
       llListenRemove(handle);
   }
   
  link_message( integer sender, integer num, string msg, key id )
  {
     if (num & RETURNING_NOTECARD_DATA)
        notecardList = llCSV2List(msg);
     chatChan = getChatChan();
   }

   listen(integer chan,string name,key id,string button)  //listen to dialog box
   {
      llSetTimerEvent(0);
      llListenRemove(handle);
      if (toucher == owner)
      {
         if(button == "public")
         {
            access = ACCESS_PUBLIC;
            sendMsg("PUBLIC");
         }
         else if(button == "group")
         {
            access = ACCESS_GROUP;
            sendMsg("GROUP");
         }
         else if(button == "owner")
         {
            access = ACCESS_OWNER;
            sendMsg("OWNER");
         }
      }
      if(button=="fire")
      {
          debugSay("menu firing");
          sendMsg("fire");
      }
      if(button=="show")
      {
         sendMsg("show");
      }
      else if(button=="hide")
      {
         sendMsg("hide");
      }
      else if(button=="reset")
      {
          sendMsg("reset");
          llResetScript();
      }
   }
}

sendMsg(string msg)
{
   #if defined REMOTE_MENU
    //  llSay(chatChan,msg); 
   #endif
   llMessageLinked(LINK_SET, 0, msg, "");
   //debugSay(msg); 
}

