// needs:
//string notecardName;
//integer notecardLineIndex;
//Query1;
//boolean done;
//list notecardList

state readNotecardToList
{
    state_entry()
    {
        llSleep(2);
        notecardName = getNotecardName("config");
        if (notecardName == "")
        {
           doneReadingNotecard = TRUE;
           llOwnerSay("Can't find the config notecard");			   
           state default;
        }
        notecardLineIndex = 0;
        Query1 = llGetNotecardLine(notecardName, notecardLineIndex++); 
        llOwnerSay("loading notecard...");
    }

    dataserver(key query_id, string data)
    {
        if ((Query1 == query_id) && (data != EOF))
        {
            if ((llSubStringIndex(data,"//") == -1) && (data != ""))
            {
               notecardList = notecardList + llCSV2List(data);
            }
            Query1 = llGetNotecardLine(notecardName, notecardLineIndex++);
        }
        if (data == EOF)
        {
            doneReadingNotecard = TRUE;
            string s = llList2CSV(notecardList);
            //debugSay(s);
            llMessageLinked(LINK_THIS, RETURNING_NOTECARD_DATA, s,""); 
            llOwnerSay("...done");
            state default;
        }
    }
}


