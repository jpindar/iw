////////////////////////
//fireworks burst controller v1.14
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the burst prim
//it link messages to the actual particle script
// it listens on the description channel then shows, hides etc.
////////////////////////////
float glowOnAmount = 0.0; //or 0.05
string SOUND = "0f76aca8-101c-48db-998c-6018faf14b62"; // a click sound
string color1 = "<1.00,0.00,0.00>";
string color2 = "<1.00,1.00,0.00>";
string texture;
key owner;
integer handle;
integer chatChan;
integer newChan;
integer access;
integer preloadFace = 2;

#include "lib.lsl"

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}

   state_entry()
   {
      texture = TEXTURE_CLASSIC;
      chatChan = objectDescToInt();
      owner = llGetOwner();
      access = PUBLIC;
      handle = llListen(chatChan, "","", "" );
      llOwnerSay("listening on channel "+(string)chatChan);
      llSetTexture(texture,preloadFace);
   }

   link_message(integer sender, integer num, string str, key id)
   {
     msgHandler(owner, str); 
   }

   listen( integer chan, string name, key id, string msg )
   {
     msgHandler(id, msg);
   }
}

msgHandler(string sender, string msg)
   {
      llSetTimerEvent(0);
      if (sender == owner)
      {
         if(msg == "public")
         {
            access = PUBLIC;
         }
         else if(msg == "group")
         {
            access = GROUP;
         }
         else if(msg == "owner")
         {
            access = OWNER;
         }
      }
      if ((access == OWNER) && (!(sender == owner)))
          return;
      if ((access == GROUP) && (!llDetectedGroup(0)))
         return;
      if (msg == "fire")
      {
         fire();
      }
      else if (msg == "hide")
      {
          llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
          llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      if ( msg == "show" )
      {
         llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
         llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         chatChan = ((integer)llDeleteSubString(msg, 0, llStringLength("set channel")));
         setObjectDesc((string)chatChan);
         llResetScript();
      }
      else if(msg =="reset")
      {
          sendMsg("reset");
          llResetScript();
      }
      else
      {
         llListenRemove(handle);
      }
}

sendMsg(string msg)
{
   //llSay(chatChan,msg);
   llMessageLinked(LINK_SET, 0, msg, "");
   //debugSay(msg);
}

fire()  //this is the only message that goes to the particle script
{
    string fireMsg = (string)color1 + (string)color2;
   // debugSay("sending fire linkmessage" + fireMsg + texture);
    llMessageLinked(LINK_SET, FIRE_CMD, fireMsg, texture);
   //llMessageLinked( LINK_SET, num, color1, texture);
   //llMessageLinked( LINK_SET, num, color2, texture);
   //llMessageLinked( LINK_SET, num, color3, texture);
}

