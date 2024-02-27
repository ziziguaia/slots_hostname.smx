#pragma semicolon 1
//強制1.7以後的新語法
#pragma newdecls required
#include <sourcemod>
#define v "3.2"


Handle needconfogl = INVALID_HANDLE;
char g_slot[64];
char finalname[256];
Handle cravhost = INVALID_HANDLE;

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

    needconfogl = CreateConVar("nc_needconfogl", "{hostname}{slot}", "创造新的conavr来合并服务器名称");
    
    cravhost = FindConVar("hostname");

    sethostname();
}


public void OnMapStart()
{
    g_slot = "[缺人]";
    getneedconfog();
    sethostname();
}


public void OnClientPutInServer()
{
    slot++;
    if(slot >= 8)
    {
        g_slot = "";
        getneedconfog();
        sethostname();
    }
    else if(slot < 8)
    {
        g_slot = "[缺人]";
        getneedconfog();
        sethostname();
    }
}

public void OnClientDisconnect()
{
    slot--;
    if(slot < 8)
    {
        g_slot = "[缺人]";
        getneedconfog();
        sethostname();
    }
    else if(slot >= 8)
    {
        g_slot = "";
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
