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
            data = llStringTrim(data,STRING_TRIM);
            integer index = llSubStringIndex(data,"//"); 
            if ((index != -1) && (data != ""))
            {
              if (index == 0)
                   data = "";
              else     
                   data = llGetSubString(data, 0, index-1);
            }
            data = llStringTrim(data,STRING_TRIM);
            if (data != "")
            {
               notecardList = notecardList + llCSV2List(data);
            }
            Query1 = llGetNotecardLine(notecardName, notecardLineIndex++);
        }
        if (data == EOF)
        {
            doneReadingNotecard = TRUE;
            string s = llList2CSV(notecardList);
            llMessageLinked(LINK_THIS, RETURNING_NOTECARD_DATA, s,"");
            llOwnerSay("...done");
            state default;
        }
    }
}



