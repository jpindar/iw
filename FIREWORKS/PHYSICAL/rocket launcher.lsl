/////////////////////
// Tracer Tech rocket launcher
// listens for commands on either a chat channel
// or a link message
//////////////////////
integer debug = TRUE;
#include "lib.lsl"

string sound = SOUND_ROCKETLAUNCH1;
float speed = 15;  //8 to 25
integer payloadParam = 3;//typically time before explosion, typically  1 to 10 
integer payloadIndex = 0; 
integer payloadParam2 = 12; //typically bouyancy * 100
float heightOffset = 0.6;
float glowOnAmount = 0.0; //or 0.05
integer chatChan;
integer handle;
integer access = ACCESS_PUBLIC;
key owner = "";
integer preloadFace = 2;

fire()
{
    string rocket;
    integer i;

    llTriggerSound(sound,1);
    repeatSound(sound);
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    rotation rot = llGetRot();
    vector pos = llGetPos()+ (<0.0,0.0,heightOffset> * rot);
    vector vel = <0,0,speed> * rot;
    for (i = 0; i<n; i++)
    {
        rocket = llGetInventoryName(INVENTORY_OBJECT,i);
        llRezAtRoot(rocket,pos,vel, rot, payloadParam + (payloadParam2*256));
    }
}

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}

   state_entry()
   {
      //llSetTexture(texture,preloadFace);
      owner = llGetOwner();
      chatChan = objectDescToInt();
      handle = llListen( chatChan, "","", "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

    /*
    touch_start(integer n)
    {
       fire();
    }
    */
	
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
      if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
          return;
      if ((access == ACCESS_GROUP) && (!llSameGroup(sender)))
         return;
      
      if ( msg == "fire" )
      {
         fire();
      }
      else if ( msg == "hide")
      {
          llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
          //llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0.0]);
	  }
      else if ( msg == "show" )
      {
         llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
         //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
         //llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         chatChan = ((integer)llDeleteSubString(msg, 0, llStringLength("set channel")));
         setObjectDesc((string)chatChan);
         llResetScript();
      }
}


