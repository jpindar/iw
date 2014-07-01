////////////////////////
//fireworks menu v1.0
//copyright Tracer Tech aka Tracer Ping 2014
/////////////////////////////
string menutext="\nChoose One:";
list buttonsOwner=["channel","reset","foo","owner","group","public", "fire","hide","show"];
list buttonsAll=["channel","reset","foo", "fire","hide","show"];
key owner;
key toucher;
integer handle;
string group;
integer chatChan;
integer menuChan;
integer newChan;

integer access;

#include "lib.lsl"
 
default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}

   state_entry()
   {
      chatChan = objectDescToInt();
      menuChan = randomChan();
      owner=llGetOwner();
      access = PUBLIC;
   }

   touch_start(integer num)
   {
      toucher=llDetectedKey(0);
      if (toucher == owner)
      {
          llDialog(toucher,menutext,buttonsOwner,menuChan);
      }
      else if ((access == GROUP) && (llDetectedGroup(0)))
      {
          llDialog(toucher,menutext,buttonsAll,menuChan);
      }
      else if ((access == PUBLIC)) 
      {
          llDialog(toucher,menutext,buttonsAll,menuChan);
      }
      else
      {
      }
      handle=llListen(menuChan,"",toucher,"");
      llSetTimerEvent(10); 
   }

   timer()
   {
       llSetTimerEvent(0);
       llListenRemove(handle);
   }
   
   listen(integer chan,string name,key id,string button)  //listen to dialog box
   {
      llSetTimerEvent(0);
      if (toucher == owner)
      {
         if(button == "public")
         {
            access = PUBLIC;
            sendMsg("PUBLIC");
         }
         else if(button == "group")
         {
            access = GROUP;
            sendMsg("GROUP");
         }
         else if(button == "owner")
         {
            access = OWNER;
            sendMsg("OWNER");
         }
      }
      if(button=="fire")
      {
          llSay(DEBUG_CHANNEL,"firing");
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
      else if (button=="channel")
      {
         state changeChannel;
      }
      else if(button=="reset")
      {
          sendMsg("reset");
          llResetScript();
      }
      if(button=="Cancel")
      {
         llListenRemove(handle);
      }
      else
      {
         llListenRemove(handle);
      }
   }
}


state changeChannel
{
     state_entry()
    {
        integer menuChan2 = randomChan();
        llTextBox(toucher,"enter new channel",menuChan2);
        integer handle2=llListen(menuChan2,"",toucher,"");
        llSetTimerEvent(10);
    }
    
    listen(integer channel,string name,key toucher,string msg)
    { 
        {
           llSetTimerEvent(0);
           newChan = (integer)msg;
           msg = "set channel " + (string)newChan;
           sendMsg(msg);
           chatChan = newChan;
           setObjectDesc((string)chatChan);
           state default;
        }
    }   
      
   timer()
   {
       state default;
   }
}

sendMsg(string msg)
{
   llSay(chatChan,msg);  
   llMessageLinked(LINK_SET, 0, msg, "");   
   llSay(DEBUG_CHANNEL,msg); 
}



