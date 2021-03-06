/*
*Fireworks burst emitter v3.0
*Tracer Ping Sept 2018
*/

string version = "3.02";

#include "LIB\lib.lsl"
#include "LIB\effects\effect.h"

string color1;
string color2;
string color3;
string lightColor;

#if def BOOMSOUND
   string sound = BOOMSOUND;
#else
   string sound = SOUND_SILENCE;
#endif

#ifdef NOFLASH
float intensity = 0.0;
#else
float intensity = 1.0;
#endif

float lightRadius = 20;
float falloff = 0.1;
float oldAlpha;
vector oldColor;
list colors;
list emitters;
list params;
float flashTime = 0.2;

#ifdef TRIPLE
   float glowAmount = 1.0; // or 0.2
   list emitterNames = ["e1"];
   integer numOfEmitters = 1;
   integer numOfIterations = 1;
   float interEmitterDelay = 0.1;
   #include "LIB\effects\effect_standard_burst_exp1.lsl"
#elif defined RAINBOW1
   float glowAmount = 0.5; // or 0.2
   list emitterNames = ["e1"];
   integer numOfEmitters = 1;
   integer numOfIterations = 6;
   //float interEmitterDelay = 0.0;
   float interEmitterDelay = systemAge;
   #include "LIB\effects\effect_standard_burst.lsl"
   #define SHARPCUTOFF
#elif defined RINGBALL
   float glowAmount = 0.5; // or 0.2
   list emitterNames = ["e1"];
   integer numOfEmitters = 1;
   integer numOfIterations = 6;
   //float interEmitterDelay = 0.0;
   float interEmitterDelay = 1.0;
   #include "LIB\effects\effect_ringball1.lsl"
   //#define DESCRIPTION " ringball "
   #define SHARPCUTOFF
#else
   float glowAmount = 0.5; // or 0.2
   //list emitterNames = ["e1"];
   list emitterNames = ["e1","e2","e3"];
   integer numOfEmitters = 1;
   integer numOfIterations = 1;
   float interEmitterDelay = 0.0;
   #include "LIB\effects\effect_standard_burst.lsl"
#endif

fire()
{
   integer i;
   integer e;
   debugSay(1,"BOOM");
   oldColor = llGetColor(ALL_SIDES);
   oldAlpha = llGetAlpha(ALL_SIDES);
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_WHITE,0.0]);
   // try repeating this section to make FAST series bursts

   for(i=0;i<numOfIterations;i++)
   {
      llPlaySound(BOOMSOUND, volume);
      repeatSound(BOOMSOUND,volume);
      color1 = llList2String(colors,i*2);
      color2 = llList2String(colors,(i*2)+1);
      if (i < numOfEmitters)
         e = llList2Integer(emitters,i);
      else
         e = llList2Integer(emitters,0);
      setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,TRUE,(vector)color1,intensity,lightRadius,falloff]);
      setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)color1,0.0]);
      setGlow(e,glowAmount);
      makeParticles(e,color1,color2);
      llSleep(flashTime);
      setGlow(LINK_SET,0.0);
      setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,lightRadius,falloff]);
      if (interEmitterDelay>0) llSleep(interEmitterDelay);
   }
   #if defined SHARPCUTOFF
       llParticleSystem([]);
       //TODO just doing llParticleSystem([]) didn't work if interEmitterDelay < systemAge
       //if you don't want interEmitterDelay >= systemAge, use this:
       //float temp = systemAge;
       //systemAge = 0.01;
       //makeParticles(e,color1,color2);
       //systemAge = temp;
   #endif
   #ifndef NOWAIT
   llSleep(systemAge+partAge);
   //llSleep(systemAge);
   #endif
   allOff();
}

allOff()
{
   integer i;
   integer e;
   setGlow(LINK_SET,0.0);
   for(i=0;i<numOfEmitters;i++)
   {
      e = llList2Integer(emitters,i);
      setParamsFast(e,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,lightRadius,falloff]);
      llLinkParticleSystem(e,[]);
   }
 //setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,oldAlpha]);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)  lightColor,intensity,lightRadius,falloff]);
   llLinkParticleSystem(LINK_SET,[]);
   setGlow(LINK_SET,0.0);
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,oldColor,oldAlpha]);
}

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
   llPreloadSound(BOOMSOUND);
   emitters = getLinknumbers(emitterNames); 
   numOfEmitters = llGetListLength(emitters);
   oldAlpha = llGetAlpha(ALL_SIDES);
   oldColor = llGetColor(ALL_SIDES);
   allOff();
   }

   //link messages come from the controller
   link_message( integer sender, integer num, string msg, key id )
   {
      integer i;
      if (num & RETURNING_NOTECARD_DATA)
      {
         list note = llCSV2List(msg);
         volume = getVolume(note);
         wind = getInteger(note, "wind");
      }
      if ( num & FIRE_CMD ) //to allow for packing more data into num
      {
         if (llStringLength(msg) > 0)
         {
            //expected format is
            //UUID,color,color......
            debugSay(2," listener got: "+ msg);
            params = llCSV2List(msg);
            integer len = llGetListLength(params);
            texture = llList2String(params,0);
            color1 = llList2String(params,1);
            lightColor = color1;
            colors = [color1];

            for (i=2; i<len; i++)
            {
               colors += llList2String(params,i);
            }
          }
          fire();
      }
   }
}

