#pragma semicolon 1
//強制1.7以後的新語法
#pragma newdecls required
#include <sourcemod>
#define v "3.2"


Handle needconfogl = INVALID_HANDLE;
char g_slot[64];
char finalname[256];
Handle cravhost = INVALID_HANDLE;
char arg1[64];
int g_slots = 8;//默认人数为8
int slot = 0;


public Plugin myinfo =
{
    name = "wonton",
    author = v,
    description = "服务器名",
    version = "1.0",
    url = "URL"
};




public void OnPluginStart()
{
    RegConsoleCmd("sm_host_slot", CMD_slot, "设置侦测人数");
    needconfogl = CreateConVar("nc_needconfogl", "{hostname}{slot}", "创造新的conavr来合并服务器名称");
    
    cravhost = FindConVar("hostname");

    HookEvent("player_team", Event_player_team);

    sethostname();
}


public void OnMapStart()
{
    g_slot = "[缺人]";
    getneedconfog();
    sethostname();
}


public void Event_player_team(Event event, const char[] name, bool dontBroadcast){
    int slot1 = GetTeamCount(2);
    int slot2 = GetTeamCount(3);
    slot = slot1 + slot2;
    sethostname_nobody();
}

int GetTeamCount(int team)
{
    int count;
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientInGame(i))
            continue;
        if (IsFakeClient(i))
            continue;
        if (GetClientTeam(i) == team)
            count++;
    }
    return count;
} 



public Action CMD_slot(int client,int args){
    GetCmdArg(1, arg1, sizeof(arg1));
    g_slots = StringToInt(arg1);
    return Plugin_Handled;
}


void sethostname_nobody(){
    if(slot >= g_slots)
    {
        g_slot = "";
        getneedconfog();
        sethostname();
    }

    if(slot < g_slots)
    {
        g_slot = "[缺人]";
        getneedconfog();
        sethostname();
    }
}



void sethostname()
{
	char hostname1[256];
	BuildPath(Path_SM, hostname1, 256, "configs/hostname/hostname.txt");
	Handle file = OpenFile(hostname1, "rb");
	if (file)
	{
		char readData[256];
		while (!IsEndOfFile(file) && ReadFileLine(file, readData, 256))
		{
            ReplaceString(finalname, sizeof(finalname), "{hostname}", readData);
            SetConVarString(cravhost, finalname);
		}
		CloseHandle(file);
	}
}


void getneedconfog()
{
    GetConVarString(needconfogl, finalname, sizeof(finalname));
    ReplaceString(finalname, sizeof(finalname), "{slot}", g_slot);
}
