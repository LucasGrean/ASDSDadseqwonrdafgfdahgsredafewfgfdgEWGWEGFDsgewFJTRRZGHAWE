#include <a_samp>
#include <ocmd>
#include <a_mysql>
#include <md5>
#include <streamer>

//Dialoge
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_BANN 3
#define DIALOG_CHAT 4

//Farben
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_BRIGHTRED 0xFF0000AA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_VIOLET 0x9955DEEE
#define COLOR_LIGHTRED 0xFF0000FF
#define COLOR_SEAGREEN 0x00EEADDF
#define COLOR_GRAYWHITE 0xEEEEFFC4
#define COLOR_LIGHTNEUTRALBLUE 0xabcdef66
#define COLOR_GREENISHGOLD 0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN 0x0FFDD349
#define COLOR_NEUTRALBLUE 0xABCDEF01
#define COLOR_LIGHTCYAN 0xAAFFCC33
#define COLOR_LEMON 0xDDDD2357
#define COLOR_MEDIUMBLUE 0x63AFF00A
#define COLOR_NEUTRAL 0xABCDEF97
#define COLOR_BLACK 0x00000000
#define COLOR_NEUTRALGREEN 0x81CFAB00
#define COLOR_DARKGREEN 0x12900BBF
#define COLOR_LIGHTGREEN 0x24FF0AB9
#define COLOR_DARKBLUE 0x300FFAAB
#define COLOR_BLUEGREEN 0x46BBAA00
#define COLOR_PINK 0xFF66FFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_DARKRED 0x660000AA

//MYSQL
#define SQL_HOST   "vweb16.nitrado.net"
#define SQL_USER   "ni241659_3sql3"
#define SQL_PASS   "aggro12"
#define SQL_DATA   "ni241659_3sql3"

//Admin Ränge
#define arank1 "Test Supporter"
#define arank2 "Supporter"
#define arank3 "Test Admin"
#define arank4 "Admin"
#define arank5 "Head Admin"
#define arank6 "Projektleiter"

//Fraktionsnamen
#define fraktname1 "Grove Family"
#define fraktname2 "Ballas"
#define fraktname3 "Lcm"
#define fraktname4 "Russen Mafia"
#define fraktname5 "Yakuza"
#define fraktname6 "S.F.Rifa"
#define fraktname7 "Ls Officer"
#define fraktname8 "Sf Officer"
#define fraktname9 "Hitman"
#define fraktname10 "Lv Officer"
#define fraktname11 "Triaden"
#define fraktname12 "Ls Vagos"
#define fraktname13 "San News"
#define fraktname14 "Ordnungs Amt"
#define fraktname15 "SA Medic"
#define fraktname16 "Regierung"

//Fraktionen Max Define
#define MAX_FRAKTIONEN (17)

enum FraktionsDaten
{
	fKasse,
	fFahrzeuge,
	fMembers,
	fMats,
	StaatsKasse
}

new FraktionsInfo[MAX_FRAKTIONEN] [FraktionsDaten];

enum SpielerDaten
{
    pName[MAX_PLAYER_NAME],
    pLevel,
    pGeld,
    pKills,
    pTode,
    pPaket,
    pWarns,
    pSpawn,
    pBaned,
    pContract,
    pMute,
    pSupMute,
    pTBan,
    pWanted,
    pPremium,
    pPremiumzeit,
    pAdminlevel,
    pSkin,
    pStaat,
    pSkinauswahl,
    pEingelogt,
    pSkinNummer,
    pOOC,
	pAdminUndercover,
	pFchat,
	pDchat,
    pFraktion
}
new SpielerInfo[MAX_PLAYERS][SpielerDaten];

//Server Banner
new Text:Servertext;

//Fraktion und Öffentliche eingänge
enum PEnterE
{
        Float:EnterX,   //Outdoor
        Float:EnterY,   //Outdoor
        Float:EnterZ,   //Outdoor
        Float:ExitX,    //Inside
        Float:ExitY,    //Inside
        Float:ExitZ,    //Inside
        Int,
        VW
};

new Float:PEnter[][PEnterE] =
{
        {1038.1316, -1339.7664, 13.7266, 376.9288, -192.4743, 1000.6328, 17, 2}, //Donut-LS
        {-144.1406, 1224.5731, 19.8992, 376.9288, -192.4743, 1000.6328, 17, 3}, //Donut Area51
        {-2767.1177, 788.8901, 52.7813, 376.9288, -192.4743, 1000.6328, 17, 4}, //Donut SF
        {172.4178, 1176.2129, 14.7645, 365.0718, -11.1250, 1001.8516, 9, 5}, //Clucking Bell
        {2393.1060, 2042.3536, 10.8203, 365.0718, -11.1250, 1001.8516, 9, 6}, //Clucking Bell
        {-2672.3770, 259.0845, 4.6328, 365.0718, -11.1250, 1001.8516, 9, 7}, //Clucking Bell
        {2398.0588, -1897.9069, 13.5469, 365.0718, -11.1250, 1001.8516, 9, 8}, //Clucking Bell
        {2420.7085, -1508.9585, 24.0000, 365.0718, -11.1250, 1001.8516, 9, 9}, //Clucking Bell
        {-1807.7166, 944.9205, 24.8906, 372.4469,-132.8290,1001.4922, 5, 10}, //Pizza
        {2104.6133, -1806.3728, 13.5547, 372.4469,-132.8290,1001.4922, 5, 2}, //Pizza
        {2471.8054, 2034.1240, 11.0625, 460.0295, -88.6260, 999.5547, 4, 3}, //BurgerShot
        {1872.9301, 2071.7893, 11.0625, 460.0295, -88.6260, 999.5547, 4, 4}, //BurgerShot
        {1158.7645, 2072.1416, 11.0625, 460.0295, -88.6260, 999.5547, 4, 5}, //BurgerShot
        {-1911.5082, 828.7873, 35.1719, 460.0295, -88.6260, 999.5547, 4, 6}, //BurgerShot
        {-2356.5618, 1008.0384, 50.8984, 460.0295, -88.6260, 999.5547, 4, 7}, //BurgerShot
        {1199.2833, -918.9497, 43.1169, 460.0295, -88.6260, 999.5547, 4, 9}, //BurgerShot
        {2158.8420, 943.3492, 10.8203, 316.3380, -169.8564, 999.6010, 6, 10}, //Ammunation
        {-1509.0056, 2608.8940, 55.8359, 316.3380, -169.8564, 999.6010, 6, 2}, //Ammunation
        {-1678.6256, 1313.4783, 7.1875, 316.3380, -169.8564, 999.6010, 6, 3}, //Ammunation
        {-2336.0146, -166.8746, 35.5547, 316.3380, -169.8564, 999.6010, 6, 4}, //Ammunation
        {-2625.6716, 209.9583, 4.6218, 316.3380, -169.8564, 999.6010, 6, 5}, //Ammunation
        {2400.4294, -1980.7820, 13.5469, 316.3380, -169.8564, 999.6010, 6, 6}, //Ammunation
        {1368.4675, -1279.7552, 13.5469, 316.3380, -169.8564, 999.6010, 6, 8}, //Ammunation
        {1352.2687, -1758.5074, 13.5078, -25.8498, -185.8688, 1003.545, 17, 9}, //24-7 LSPD
        {1315.5540, -898.0838, 39.5781, 6.09179, -29.27188, 1003.5498, 10, 10}, //24-7 BSN
        {1352.2687, -1758.5074, 13.5078, -25.8498, -185.8688, 1003.545, 17, 1}, //24-7 BSN-Tanke
        {2194.5679, 1990.9087, 12.2969, 6.09179, -29.27188, 1003.5498, 10, 2}, //24-7 LV
        {-2160.6926, 578.6028, 35.1719, -25.8498, -185.8688, 1003.545, 17, 3}, //24-7 SF
        {1929.2341, -1776.3066, 13.5469, 6.09179, -29.27188, 1003.5498, 10, 4}, //24-7 Mülldeponie
        {1555.1340, -1675.6147, 16.1953, 246.7345, 62.3530, 1003.6406, 6, 0}, //Los Santos Polizei
        {1524.7898, -1677.7972, 5.8906, 246.5157, 87.4060, 1003.6406, 6, 0}, //Los Santos Polizei Garage Eingang
        {2290.0583, 2431.7976, 10.8203, 288.8973, 167.6461, 1007.1719, 3, 0}, //Las Venturas Polizei
        {2282.3735, 2423.5994, -7.2500, 300.6819, 191.1065, 1007.1719, 3, 0}, //Las Venturas Polizei Garage
        {-1605.4651, 711.3160 ,13.8672, 246.375991, 109.245994, 1003.218750, 10, 0}, //Fbi Eingang
        {-1606.0687, 673.0027, -5.2422, 227.7538, 114.7517, 999.0156, 10, 0} //Fbi Garage
};

//OOC Chat
new OOCServer;

//Gangfight System
new Text:Angreifertext;
new Text:Verteidigertext;
new Text:Zeittext;
new Text:Zonentext;

new AngreiferCount;
new VerteidigerCount;

new Angreifer;
new Verteidiger;

new VerteidigerFarbe1;
new VerteidigerFarbe2;
new VerteidigerFarbe3;
new VerteidigerFarbe4;
new VerteidigerFarbe5;
new VerteidigerFarbe6;
new VerteidigerFarbe7;
new VerteidigerFarbe8;
new VerteidigerFarbe9;
new VerteidigerFarbe10;
new VerteidigerFarbe11;
new AngreiferFarbe;

new GangZonenBesitz1;
new GangZonenBesitz2;
new GangZonenBesitz3;
new GangZonenBesitz4;
new GangZonenBesitz5;
new GangZonenBesitz6;
new GangZonenBesitz7;
new GangZonenBesitz8;
new GangZonenBesitz9;
new GangZonenBesitz10;
new GangZonenBesitz11;

new Gangfight;
new GangfightZeit;
new Punktelimit;

new Gangzone1;
new Gangzone2;
new Gangzone3;
new Gangzone4;
new Gangzone5;
new Gangzone6;
new Gangzone7;
new Gangzone8;
new Gangzone9;
new Gangzone10;
new Gangzone11;

new PlayaDelSeville;
new LasColinas;
new bauernhof;
new golf;
new mili;
new ffh;
new kleinstadt;
new tierarobada;
new parkhaus;
new indu;
new AngelPine;

main()
{
	print("\n----------------------------------");
	print(" German Grean Family Roleplay");
	print("----------------------------------\n");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////Timer/////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

forward GangfightTimer();
forward KickTimer(playerid);

public OnGameModeInit()
{
	SetGameModeText("German Grean Roleplay");
	
	//mit Mysql verbinden
	Connect_To_Database();
	
	//Server Variablen
	OOCServer = 0;
	
	//Fraktions Daten Laden
	for(new i = 1; i < MAX_FRAKTIONEN; i++)
	{
		new Fraktion[64];
        switch(i)
        {
            case 1:{Fraktion=fraktname1;}
            case 2:{Fraktion=fraktname2;}
            case 3:{Fraktion=fraktname3;}
            case 4:{Fraktion=fraktname4;}
            case 5:{Fraktion=fraktname5;}
            case 6:{Fraktion=fraktname6;}
            case 7:{Fraktion=fraktname7;}
            case 8:{Fraktion=fraktname8;}
            case 9:{Fraktion=fraktname9;}
            case 10:{Fraktion=fraktname10;}
            case 11:{Fraktion=fraktname11;}
            case 12:{Fraktion=fraktname12;}
            case 13:{Fraktion=fraktname13;}
            case 14:{Fraktion=fraktname14;}
            case 15:{Fraktion=fraktname15;}
            case 16:{Fraktion=fraktname16;}
        }
	
        LoadFraktion(i);
        new String[64];
       	format(String,sizeof(String), "Fraktion %d %s Geladen",i, Fraktion);
        print(String);
	}
	//Gangzonen Laden
	GangzonenLaden();
	
	//Gangfight System
	GangfightZeit = 0;
	Punktelimit = 50;
	
	//Server
	Servertext = TextDrawCreate(556 ,23 , "~b~Grean~n~   ~w~Roleplay");
    TextDrawFont(Servertext , 1);
    TextDrawLetterSize(Servertext , 0.217999, 1.288532);
    TextDrawColor(Servertext , 0xffffffFF);
    TextDrawSetOutline(Servertext , false);
    TextDrawSetProportional(Servertext , true);
    TextDrawSetShadow(Servertext , 1);
	
	//Gangfight
    Angreifertext = TextDrawCreate(42 ,303 , " ");
    TextDrawFont(Angreifertext , 1);
    TextDrawLetterSize(Angreifertext , 0.217999, 1.288532);
    TextDrawColor(Angreifertext , 0xffffffFF);
    TextDrawSetOutline(Angreifertext , false);
    TextDrawSetProportional(Angreifertext , true);
    TextDrawSetShadow(Angreifertext , 1);

    Verteidigertext = TextDrawCreate(42 ,313 , " ");
    TextDrawFont(Verteidigertext , 1);
    TextDrawLetterSize(Verteidigertext , 0.217999, 1.288532);
    TextDrawColor(Verteidigertext , 0xffffffFF);
    TextDrawSetOutline(Verteidigertext , false);
    TextDrawSetProportional(Verteidigertext , true);
    TextDrawSetShadow(Verteidigertext , 1);

    Zeittext = TextDrawCreate(42 ,323 , " ");
    TextDrawFont(Zeittext , 1);
    TextDrawLetterSize(Zeittext , 0.217999, 1.288532);
    TextDrawColor(Zeittext , 0xffffffFF);
    TextDrawSetOutline(Zeittext , false);
    TextDrawSetProportional(Zeittext , true);
    TextDrawSetShadow(Zeittext , 1);

    Zonentext = TextDrawCreate(42 ,288 , " ");
    TextDrawFont(Zonentext , 1);
    TextDrawLetterSize(Zonentext , 0.227999, 1.298532);
    TextDrawColor(Zonentext , 0xffffffFF);
    TextDrawSetOutline(Zonentext , false);
    TextDrawSetProportional(Zonentext , true);
    TextDrawSetShadow(Zonentext , 1);
    
    //Gangfight Zonen
    PlayaDelSeville = GangZoneCreate(2719.0447,-2034.8972, 2815.9976,-1899.4086);
    LasColinas = GangZoneCreate(2414.0498,-1052.4003, 2626.5676,-936.5402);
    bauernhof = GangZoneCreate(910.9499,-400.2791, 1132.0104,-272.6128);
    golf = GangZoneCreate(1119.6848,2709.6711, 1532.9116,2862.4202);
    mili = GangZoneCreate(2479.6082, 2889.3931, 2782.9402, 2656.8315);
    ffh = GangZoneCreate(-5.4260,2422.2090, 422.4625,2598.0898);
    kleinstadt = GangZoneCreate(-1570.6669,2510.6406, -1295.8569,2755.3601);
    tierarobada = GangZoneCreate(-938.3699,1383.6951, -612.7709,1644.6853);
    parkhaus  = GangZoneCreate(-1877.8513, 1258.8229, -1736.5641, 1331.0953);
    indu = GangZoneCreate(-2201.4199,-281.7826, -2013.5450,-83.6795);
    AngelPine = GangZoneCreate(-2294.4856,-2578.3203, -1949.9348,-2236.0884);
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////Timer/////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    SetTimer("GangfightTimer",1000*60,false);

	return 1;
}

public OnGameModeExit()
{
	//Fraktion Daten Speichern
	for(new i = 1; i < MAX_FRAKTIONEN; i++)
	{
		new Fraktion[64];
        switch(i)
        {
            case 1:{Fraktion=fraktname1;}
            case 2:{Fraktion=fraktname2;}
            case 3:{Fraktion=fraktname3;}
            case 4:{Fraktion=fraktname4;}
            case 5:{Fraktion=fraktname5;}
            case 6:{Fraktion=fraktname6;}
            case 7:{Fraktion=fraktname7;}
            case 8:{Fraktion=fraktname8;}
            case 9:{Fraktion=fraktname9;}
            case 10:{Fraktion=fraktname10;}
            case 11:{Fraktion=fraktname11;}
            case 12:{Fraktion=fraktname12;}
            case 13:{Fraktion=fraktname13;}
            case 14:{Fraktion=fraktname14;}
            case 15:{Fraktion=fraktname15;}
            case 16:{Fraktion=fraktname16;}
        }

        SaveFraktion(i);
        new String[64];
       	format(String,sizeof(String), "Fraktion %d %s Gespeichert",i, Fraktion);
        print(String);
	}

	//GangZonen Speichern
	GangzonenSpeichern();
	
	//GangZonen Erstellen
	PlayaDelSeville = GangZoneCreate(2719.0447,-2034.8972, 2815.9976,-1899.4086);
    LasColinas = GangZoneCreate(2414.0498,-1052.4003, 2626.5676,-936.5402);
    bauernhof = GangZoneCreate(910.9499,-400.2791, 1132.0104,-272.6128);
    golf = GangZoneCreate(1119.6848,2709.6711, 1532.9116,2862.4202);
    mili = GangZoneCreate(2479.6082, 2889.3931, 2782.9402, 2656.8315);
    ffh = GangZoneCreate(-5.4260,2422.2090, 422.4625,2598.0898);
    kleinstadt = GangZoneCreate(-1570.6669,2510.6406, -1295.8569,2755.3601);
    tierarobada = GangZoneCreate(-938.3699,1383.6951, -612.7709,1644.6853);
    parkhaus  = GangZoneCreate(-1877.8513, 1258.8229, -1736.5641, 1331.0953);
    indu = GangZoneCreate(-2201.4199,-281.7826, -2013.5450,-83.6795);
    AngelPine = GangZoneCreate(-2294.4856,-2578.3203, -1949.9348,-2236.0884);
	return 1;
}

public KickTimer(playerid)
{
    SavePlayer(playerid);
    TogglePlayerControllable(playerid,false);
    Kick(playerid);
    return 1;
}

public GangfightTimer()
{
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    if(Gangfight == 1)
    {
		if(GangfightZeit > 0)
		{
			GangfightZeit--;
			new Str4[64];
        	new Str2[128];
        	new Str3[64];
        	format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
        	TextDrawSetString(Verteidigertext, Str2);
        	format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
        	TextDrawSetString(Angreifertext, Str3);
        	format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
        	TextDrawSetString(Zeittext, Str4);
		}
		if(GangfightZeit == 0)
		{
    		if(AngreiferCount > VerteidigerCount)
    		{
    			new Str2[128];
    			new Str3[64];
    			format(Str2,sizeof(Str2), " ",AngreiferCount);
    			TextDrawSetString(Verteidigertext, Str2);
    			format(Str3,sizeof(Str3), " ",VerteidigerCount);
    			new Str4[64];
    			format(Str4,sizeof(Str4), " ",GangfightZeit);
    			TextDrawSetString(Zeittext, Str4);
    			TextDrawSetString(Zonentext, " ");
    			SendClientMessageToAll(COLOR_LIGHTBLUE, "Das Gangfight ist zu ende da sie Zeit abgelaufen ist die Angreifer übernahmen das Gebiet!");
    			if(Gangzone1 == 1)
				{
        			GangZonenBesitz1 = Angreifer;
        			Gangzone1 = 0;
        			GangZoneShowForAll(PlayaDelSeville,AngreiferFarbe);
				}
				if(Gangzone2 == 1)
				{
        			GangZonenBesitz2 = Angreifer;
        			Gangzone2 = 0;
        			GangZoneShowForAll(LasColinas,AngreiferFarbe);
				}
				if(Gangzone3 == 1)
				{
        			GangZonenBesitz3 = Angreifer;
					Gangzone3 = 0;
        			GangZoneShowForAll(bauernhof,AngreiferFarbe);
				}
				if(Gangzone4 == 1)
				{
        			GangZonenBesitz4 = Angreifer;
        			Gangzone4 = 0;
        			GangZoneShowForAll(golf,AngreiferFarbe);
				}
				if(Gangzone5 == 1)
				{
        			GangZonenBesitz5 = Angreifer;
        			Gangzone5 = 0;
        			GangZoneShowForAll(mili,AngreiferFarbe);
				}
				if(Gangzone6 == 1)
				{
        			GangZonenBesitz6 = Angreifer;
        			Gangzone6 = 0;
        			GangZoneShowForAll(kleinstadt,AngreiferFarbe);
				}
				if(Gangzone7 == 1)
				{
        			GangZonenBesitz7 = Angreifer;
        			Gangzone7 = 0;
        			GangZoneShowForAll(tierarobada,AngreiferFarbe);
				}
				if(Gangzone8 == 1)
				{
        			GangZonenBesitz8 = Angreifer;
        			Gangzone8 = 0;
        			GangZoneShowForAll(parkhaus,AngreiferFarbe);
				}
				if(Gangzone9 == 1)
				{
        			GangZonenBesitz9 = Angreifer;
        			Gangzone9 = 0;
        			GangZoneShowForAll(indu,AngreiferFarbe);
				}
				if(Gangzone10 == 1)
				{
        			GangZonenBesitz10 = Angreifer;
        			Gangzone10 = 0;
        			GangZoneShowForAll(AngelPine,AngreiferFarbe);
				}
				if(Gangzone11 == 1)
				{
        			GangZonenBesitz11 = Angreifer;
        			Gangzone11 = 0;
        			GangZoneShowForAll(ffh,AngreiferFarbe);
				}
				AngreiferCount = 0;
    			VerteidigerCount = 0;
    			Gangfight = 0;
    			Angreifer = 0;
    			Verteidiger = 0;
				GangfightZeit = 0;
				GangzonenSpeichern();
			}
    		if(AngreiferCount <= VerteidigerCount)
    		{
    			new Str2[128];
    			new Str3[64];
    			format(Str2,sizeof(Str2), " ",VerteidigerName, VerteidigerCount);
    			TextDrawSetString(Verteidigertext, Str2);
    			format(Str3,sizeof(Str3), " ",AngreiferName, AngreiferCount);
    			TextDrawSetString(Angreifertext, Str3);
    			new Str4[64];
    			format(Str4,sizeof(Str4), " ",GangfightZeit);
    			TextDrawSetString(Zeittext, Str4);
    			TextDrawSetString(Zonentext, " ");
    			SendClientMessageToAll(COLOR_LIGHTBLUE, "Das Gangfight ist zu ende da sie Zeit abgelaufen ist die Verteidiger konnten das Gebiet halten!");
    			AngreiferCount = 0;
    			VerteidigerCount = 0;
    			Gangfight = 0;
    			Angreifer = 0;
    			Verteidiger = 0;
    			GangfightZeit = 0;
    			if(Gangzone1 == 1)
				{
        			Gangzone1 = 0;
				}
				if(Gangzone2 == 1)
				{
       		    	Gangzone2 = 0;
				}
				if(Gangzone3 == 1)
				{
        			Gangzone3 = 0;
				}
				if(Gangzone4 == 1)
				{
        			Gangzone4 = 0;
				}
				if(Gangzone5 == 1)
				{
        			Gangzone5 = 0;
				}
				if(Gangzone6 == 1)
				{
       		 		Gangzone6 = 0;
				}
				if(Gangzone7 == 1)
				{
        			Gangzone7 = 0;
				}
				if(Gangzone8 == 1)
				{
        			Gangzone8 = 0;
				}
				if(Gangzone9 == 1)
				{
        			Gangzone9 = 0;
				}
				if(Gangzone10 == 1)
				{
        			Gangzone10 = 0;
				}
				if(Gangzone11 == 1)
				{
        			Gangzone11 = 0;
				}
    			//Gangzonen
    			GangzonenSpeichern();
			}
	    }
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    //Server Join Nachricht
	new string[128];
    format(string,sizeof(string),"[Beigetreten] %s hat den Server betreten",SpielerName(playerid));
    SendClientMessageToAll(COLOR_DARKGREEN,string);
    
    //Server Text
    TextDrawShowForPlayer(playerid, Servertext);

	//Spieler Account
	if(mysql_CheckAccount(playerid) == 0)
	{
        ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_PASSWORD,"Register Vorgang","Herzlich Willkommen auf Grean Roleplay\nBevor du loslegen kannst musst du dich zuerst registrieren.\nGib bitte dein gewünschtes Passwort an!","Register","Abbrechen");
    }
    else if(mysql_CheckAccount(playerid) == 1)
    {
        ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login Vorgang","Herzlich Willkommen zurück auf Grean Roleplay!\nGib bitte dein Passwort ein","Login","Abbrechen");
    }

    //Gangfight fix
    RemoveBuildingForPlayer(playerid, 985, 2497.4063, 2777.0703, 11.5313, 0.25);
    RemoveBuildingForPlayer(playerid, 986, 2497.4063, 2769.1094, 11.5313, 0.25);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    //MYSQL Spieler Speichern
	SavePlayer(playerid);

	//Disconnect Nachricht
    new string[64], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,MAX_PLAYER_NAME);
    switch(reason)
    {
        case 0: format(string,sizeof string,"%s hat den Server verlassen. (Timeout)",name);
        case 1: format(string,sizeof string,"%s hat den Server verlassen. (Verlassen)",name);
        case 2: format(string,sizeof string,"%s hat den Server verlassen. (Kick/Ban)",name);
    }
    SendClientMessageToAll(COLOR_DARKRED,string);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//Abfrage ob der Spieler eingelogt ist
	//if(SpielerInfo[playerid][pEingelogt]!=1)
    //{
    //   Kick(playerid);
    //}
    
    //Spieler Skin Laden und Setzen
    SetPlayerSkin(playerid,SpielerInfo[playerid][pSkin]);

	//Gangfight System
    if(Gangfight == 1)
	{
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
    }

    switch(GangZonenBesitz1)
    {
        case 1:{VerteidigerFarbe1=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe1=COLOR_PINK;}
        case 3:{VerteidigerFarbe1=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe1=COLOR_GREY;}
        case 5:{VerteidigerFarbe1=COLOR_WHITE;}
        case 6:{VerteidigerFarbe1=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe1=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe1=COLOR_YELLOW;}
    }
    GangZoneShowForAll(PlayaDelSeville,VerteidigerFarbe1);

    switch(GangZonenBesitz2)
    {
        case 1:{VerteidigerFarbe2=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe2=COLOR_PINK;}
        case 3:{VerteidigerFarbe2=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe2=COLOR_GREY;}
        case 5:{VerteidigerFarbe2=COLOR_WHITE;}
        case 6:{VerteidigerFarbe2=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe2=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe2=COLOR_YELLOW;}
    }
    GangZoneShowForAll(LasColinas,VerteidigerFarbe2);

    switch(GangZonenBesitz3)
    {
        case 1:{VerteidigerFarbe3=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe3=COLOR_PINK;}
        case 3:{VerteidigerFarbe3=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe3=COLOR_GREY;}
        case 5:{VerteidigerFarbe3=COLOR_WHITE;}
        case 6:{VerteidigerFarbe3=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe3=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe3=COLOR_YELLOW;}
    }
    GangZoneShowForAll(bauernhof,VerteidigerFarbe3);

    switch(GangZonenBesitz4)
    {
        case 1:{VerteidigerFarbe4=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe4=COLOR_PINK;}
        case 3:{VerteidigerFarbe4=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe4=COLOR_GREY;}
        case 5:{VerteidigerFarbe4=COLOR_WHITE;}
        case 6:{VerteidigerFarbe4=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe4=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe4=COLOR_YELLOW;}
    }
    GangZoneShowForAll(golf,VerteidigerFarbe4);

    switch(GangZonenBesitz5)
    {
        case 1:{VerteidigerFarbe5=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe5=COLOR_PINK;}
        case 3:{VerteidigerFarbe5=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe5=COLOR_GREY;}
        case 5:{VerteidigerFarbe5=COLOR_WHITE;}
        case 6:{VerteidigerFarbe5=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe5=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe5=COLOR_YELLOW;}
    }
    GangZoneShowForAll(mili,VerteidigerFarbe5);

    switch(GangZonenBesitz6)
    {
        case 1:{VerteidigerFarbe6=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe6=COLOR_PINK;}
        case 3:{VerteidigerFarbe6=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe6=COLOR_GREY;}
        case 5:{VerteidigerFarbe6=COLOR_WHITE;}
        case 6:{VerteidigerFarbe6=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe6=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe6=COLOR_YELLOW;}
    }
    GangZoneShowForAll(kleinstadt,VerteidigerFarbe6);

    switch(GangZonenBesitz7)
    {
        case 1:{VerteidigerFarbe7=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe7=COLOR_PINK;}
        case 3:{VerteidigerFarbe7=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe7=COLOR_GREY;}
        case 5:{VerteidigerFarbe7=COLOR_WHITE;}
        case 6:{VerteidigerFarbe7=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe7=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe7=COLOR_YELLOW;}
    }
    GangZoneShowForAll(tierarobada,VerteidigerFarbe7);

    switch(GangZonenBesitz8)
    {
        case 1:{VerteidigerFarbe8=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe8=COLOR_PINK;}
        case 3:{VerteidigerFarbe8=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe8=COLOR_GREY;}
        case 5:{VerteidigerFarbe8=COLOR_WHITE;}
        case 6:{VerteidigerFarbe8=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe8=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe8=COLOR_YELLOW;}
    }
    GangZoneShowForAll(parkhaus,VerteidigerFarbe8);

    switch(GangZonenBesitz9)
    {
        case 1:{VerteidigerFarbe9=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe9=COLOR_PINK;}
        case 3:{VerteidigerFarbe9=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe9=COLOR_GREY;}
        case 5:{VerteidigerFarbe9=COLOR_WHITE;}
        case 6:{VerteidigerFarbe9=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe9=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe9=COLOR_YELLOW;}
    }
    GangZoneShowForAll(indu,VerteidigerFarbe9);

    switch(GangZonenBesitz10)
    {
        case 1:{VerteidigerFarbe10=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe10=COLOR_PINK;}
        case 3:{VerteidigerFarbe10=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe10=COLOR_GREY;}
        case 5:{VerteidigerFarbe10=COLOR_WHITE;}
        case 6:{VerteidigerFarbe10=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe10=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe10=COLOR_YELLOW;}
    }
    GangZoneShowForAll(AngelPine,VerteidigerFarbe10);

    switch(GangZonenBesitz11)
    {
        case 1:{VerteidigerFarbe11=COLOR_DARKGREEN;}
        case 2:{VerteidigerFarbe11=COLOR_PINK;}
        case 3:{VerteidigerFarbe11=COLOR_DARKBLUE;}
        case 4:{VerteidigerFarbe11=COLOR_GREY;}
        case 5:{VerteidigerFarbe11=COLOR_WHITE;}
        case 6:{VerteidigerFarbe11=COLOR_LIGHTBLUE;}
        case 11:{VerteidigerFarbe11=COLOR_DARKRED;}
        case 12:{VerteidigerFarbe11=COLOR_YELLOW;}
    }
    GangZoneShowForAll(ffh,VerteidigerFarbe11);

    if(Gangzone1 == 1)
    {
        GangZoneFlashForAll(PlayaDelSeville,AngreiferFarbe);
    }
    if(Gangzone2 == 1)
    {
        GangZoneFlashForAll(LasColinas,AngreiferFarbe);
    }
    if(Gangzone3 == 1)
    {
        GangZoneFlashForAll(bauernhof,AngreiferFarbe);
    }
    if(Gangzone4 == 1)
    {
        GangZoneFlashForAll(golf,AngreiferFarbe);
    }
    if(Gangzone5 == 1)
    {
        GangZoneFlashForAll(mili,AngreiferFarbe);
    }
    if(Gangzone6 == 1)
    {
        GangZoneFlashForAll(kleinstadt,AngreiferFarbe);
    }
    if(Gangzone7 == 1)
    {
        GangZoneFlashForAll(tierarobada,AngreiferFarbe);
    }
    if(Gangzone8 == 1)
    {
        GangZoneFlashForAll(parkhaus,AngreiferFarbe);
    }
    if(Gangzone9 == 1)
    {
        GangZoneFlashForAll(indu,AngreiferFarbe);
    }
    if(Gangzone10 == 1)
    {
        GangZoneFlashForAll(AngelPine,AngreiferFarbe);
    }
    if(Gangzone11 == 1)
    {
        GangZoneFlashForAll(ffh,AngreiferFarbe);
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	//Gangfight System
    if(Gangfight == 1)
    {
        if(Gangzone1 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 2719.0447,-2034.8972, 2815.9976,-1899.4086))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 2719.0447,-2034.8972, 2815.9976,-1899.4086))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 2719.0447,-2034.8972, 2815.9976,-1899.4086))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 2719.0447,-2034.8972, 2815.9976,-1899.4086))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone2 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 2414.0498,-1052.4003, 2626.5676,-936.5402))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 2414.0498,-1052.4003, 2626.5676,-936.5402))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 2414.0498,-1052.4003, 2626.5676,-936.5402))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 2414.0498,-1052.4003, 2626.5676,-936.5402))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone3 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 910.9499,-400.2791, 1132.0104,-272.6128))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 910.9499,-400.2791, 1132.0104,-272.6128))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 910.9499,-400.2791, 1132.0104,-272.6128))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 910.9499,-400.2791, 1132.0104,-272.6128))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone4 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 1119.6848,2709.6711, 1532.9116,2862.4202))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 1119.6848,2709.6711, 1532.9116,2862.4202))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 2479.6082, 2889.3931, 2782.9402, 2656.8315))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 1119.6848,2709.6711, 1532.9116,2862.4202))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone5 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 2479.6082, 2889.3931, 2782.9402, 2656.8315))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 2479.6082, 2889.3931, 2782.9402, 2656.8315))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, 2479.6082, 2889.3931, 2782.9402, 2656.8315))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, 2479.6082, 2889.3931, 2782.9402, 2656.8315))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone6 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -1570.6669,2510.6406, -1295.8569,2755.3601))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -1570.6669,2510.6406, -1295.8569,2755.3601))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -1570.6669,2510.6406, -1295.8569,2755.3601))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -1570.6669,2510.6406, -1295.8569,2755.3601))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone7 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -938.3699,1383.6951, -612.7709,1644.6853))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -938.3699,1383.6951, -612.7709,1644.6853))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -938.3699,1383.6951, -612.7709,1644.6853))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -938.3699,1383.6951, -612.7709,1644.6853))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone8 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -1877.8513, 1258.8229, -1736.5641, 1331.0953))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -1877.8513, 1258.8229, -1736.5641, 1331.0953))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -1877.8513, 1258.8229, -1736.5641, 1331.0953))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -1877.8513, 1258.8229, -1736.5641, 1331.0953))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone9 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -2201.4199,-281.7826, -2013.5450,-83.6795))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -2201.4199,-281.7826, -2013.5450,-83.6795))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -2201.4199,-281.7826, -2013.5450,-83.6795))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -2201.4199,-281.7826, -2013.5450,-83.6795))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone10 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -2294.4856,-2578.3203, -1949.9348,-2236.0884))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -2294.4856,-2578.3203, -1949.9348,-2236.0884))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -2294.4856,-2578.3203, -1949.9348,-2236.0884))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -2294.4856,-2578.3203, -1949.9348,-2236.0884))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }
        if(Gangzone11 == 1)
        {
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -5.4260,2422.2090, 422.4625,2598.0898))
            {
                GangfightVerteidigerKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -5.4260,2422.2090, 422.4625,2598.0898))
            {
                GangfightAngreiferKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Verteidiger && SpielerInfo[playerid][pFraktion]==Verteidiger && IsPlayerInArea(playerid, -5.4260,2422.2090, 422.4625,2598.0898))
            {
                GangfightVerteidigerTeamKill(killerid, playerid);
            }
            if(SpielerInfo[killerid][pFraktion]==Angreifer && SpielerInfo[playerid][pFraktion]==Angreifer && IsPlayerInArea(playerid, -5.4260,2422.2090, 422.4625,2598.0898))
            {
                GangfightAngreiferTeamKill(killerid, playerid);
            }
        }

        if(AngreiferCount >= Punktelimit && VerteidigerCount <= Punktelimit)
        {
            SendClientMessageToAll(COLOR_LIGHTBLUE, "Die Angreifer übernahmen das Gebiet!");
            TextDrawSetString(Verteidigertext, " ");
            TextDrawSetString(Angreifertext, " ");
		    TextDrawSetString(Zeittext, " ");

		    if(Gangzone1 == 1)
	        {
                GangZonenBesitz1 = Angreifer;
                Gangzone1 = 0;
                GangZoneShowForAll(PlayaDelSeville,AngreiferFarbe);
	        }
	        if(Gangzone2 == 1)
	        {
                GangZonenBesitz2 = Angreifer;
                Gangzone2 = 0;
                GangZoneShowForAll(LasColinas,AngreiferFarbe);
	        }
	        if(Gangzone3 == 1)
	        {
                GangZonenBesitz3 = Angreifer;
                Gangzone3 = 0;
                GangZoneShowForAll(bauernhof,AngreiferFarbe);
	        }
	        if(Gangzone4 == 1)
	        {
                GangZonenBesitz4 = Angreifer;
                Gangzone4 = 0;
                GangZoneShowForAll(golf,AngreiferFarbe);
	        }
	        if(Gangzone5 == 1)
	        {
                GangZonenBesitz5 = Angreifer;
                Gangzone5 = 0;
                GangZoneShowForAll(mili,AngreiferFarbe);
	        }
	        if(Gangzone6 == 1)
	        {
                GangZonenBesitz6 = Angreifer;
                Gangzone6 = 0;
                GangZoneShowForAll(kleinstadt,AngreiferFarbe);
	        }
	        if(Gangzone7 == 1)
	        {
                GangZonenBesitz7 = Angreifer;
                Gangzone7 = 0;
                GangZoneShowForAll(tierarobada,AngreiferFarbe);
	        }
	        if(Gangzone8 == 1)
	        {
                GangZonenBesitz8 = Angreifer;
                Gangzone8 = 0;
                GangZoneShowForAll(parkhaus,AngreiferFarbe);
	        }
	        if(Gangzone9 == 1)
	        {
                GangZonenBesitz9 = Angreifer;
                Gangzone9 = 0;
                GangZoneShowForAll(indu,AngreiferFarbe);
	        }
	        if(Gangzone10 == 1)
	        {
                GangZonenBesitz10 = Angreifer;
                Gangzone10 = 0;
                GangZoneShowForAll(AngelPine,AngreiferFarbe);
	        }
	        if(Gangzone11 == 1)
	        {
                GangZonenBesitz11 = Angreifer;
                Gangzone11 = 0;
                GangZoneShowForAll(ffh,AngreiferFarbe);
	        }
	        AngreiferCount = 0;
            VerteidigerCount = 0;
            Gangfight = 0;
            Angreifer = 0;
            Verteidiger = 0;
            GangfightZeit = 0;
            GangzonenSpeichern();
        }
        if(AngreiferCount <= Punktelimit && VerteidigerCount >= Punktelimit)
        {
            TextDrawSetString(Verteidigertext, " ");
            TextDrawSetString(Angreifertext, " ");
            TextDrawSetString(Zeittext, " ");
            SendClientMessageToAll(COLOR_LIGHTBLUE, "Die Verteidiger konnten das Gebiet halten!");
            AngreiferCount = 0;
            VerteidigerCount = 0;
            GangfightZeit = 0;
            Gangfight = 0;
            Angreifer = 0;
            Verteidiger = 0;

            if(Gangzone1 == 1)
	        {
                Gangzone1 = 0;
	        }
	        if(Gangzone2 == 1)
	        {
                Gangzone2 = 0;
	        }
	        if(Gangzone3 == 1)
	        {
                Gangzone3 = 0;
	        }
	        if(Gangzone4 == 1)
	        {
                Gangzone4 = 0;
	        }
            if(Gangzone5 == 1)
	        {
                Gangzone5 = 0;
	        }
	        if(Gangzone6 == 1)
	        {
                Gangzone6 = 0;
	        }
	        if(Gangzone7 == 1)
	        {
                Gangzone7 = 0;
	        }
            if(Gangzone8 == 1)
	        {
                Gangzone8 = 0;
	        }
	        if(Gangzone9 == 1)
	        {
                Gangzone9 = 0;
	        }
	        if(Gangzone10 == 1)
	        {
                Gangzone10 = 0;
	        }
	        if(Gangzone11 == 1)
	        {
                Gangzone11 = 0;
	        }
	        GangzonenSpeichern();
        }
    }
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////Befehle///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ocmd:test1(playerid)
{
SendClientMessage(playerid, COLOR_DARKGREEN, "Dies ist ein Test1.");
return 1;
}



ocmd:test(playerid)
{
	SpielerInfo[playerid][pFraktion] = 1;
	return 1;
}

ocmd:OOC(playerid)
{
	if(SpielerInfo[playerid][pAdminlevel]>=1)
	{
        if(OOCServer == 0)
        {
            OOCServer=1;
            SendClientMessage(playerid, COLOR_DARKGREEN, "Du hast den OOC Aktiviert.");
	    }
	    if(OOCServer == 1)
        {
            OOCServer=0;
            SendClientMessage(playerid, COLOR_DARKGREEN, "Du hast den OOC Deaktiviert.");
	    }
	}
	else
	{
		SendClientMessage(playerid, COLOR_DARKRED, "Du bist kein Test Supporter.");
	}
}

ocmd:frakkasse(playerid, params[])
{
	new String[256], Abfrage[24], Betrag;
	new FrakID = SpielerInfo[playerid][pFraktion];
	new FraktionsKasse = FraktionsInfo[FrakID][fKasse];

    new FraktionsName[64];
   	switch(FrakID)
   	{
   	    case 1:{FraktionsName=fraktname1;}
       	case 2:{FraktionsName=fraktname2;}
       	case 3:{FraktionsName=fraktname3;}
       	case 4:{FraktionsName=fraktname4;}
       	case 5:{FraktionsName=fraktname5;}
       	case 6:{FraktionsName=fraktname6;}
       	case 7:{FraktionsName=fraktname7;}
       	case 8:{FraktionsName=fraktname8;}
       	case 9:{FraktionsName=fraktname9;}
       	case 10:{FraktionsName=fraktname10;}
       	case 11:{FraktionsName=fraktname11;}
       	case 12:{FraktionsName=fraktname12;}
       	case 13:{FraktionsName=fraktname13;}
       	case 14:{FraktionsName=fraktname14;}
       	case 15:{FraktionsName=fraktname15;}
       	case 16:{FraktionsName=fraktname16;}
   	}
	
	if(sscanf(params,"si",Abfrage,Betrag))
	{
	    SendClientMessage(playerid,COLOR_GREY,"/Frakkasse [Ein/auszahlen] [Betrag]");
        SendClientMessage(playerid, COLOR_YELLOW, "||---------------------------------------------------||");
        format(String,sizeof(String), "  %s Kasse: %d$",FraktionsName, FraktionsKasse);
        SendClientMessage(playerid, COLOR_WHITE, String);
        SendClientMessage(playerid, COLOR_YELLOW, "||---------------------------------------------------||");
	}
	else
	{
     	if(strfind(Abfrage, "einzahlen", true) != -1)
     	{
		 	if(SpielerInfo[playerid][pGeld]<Betrag)return SendClientMessage(playerid,COLOR_DARKRED,"Du hast nicht genug Geld.");

		 	new NeueFraktionsKasse = Betrag+FraktionsKasse;
		 	AntiCheat_GivePlayerMoney(playerid,-Betrag);
		 	FraktionsInfo[FrakID][fKasse]=NeueFraktionsKasse;
    
         	SendClientMessage(playerid, COLOR_YELLOW, "||---------------------------------------------------||");
      	 	format(String,sizeof(String), "  Alter Stand: %d$",FraktionsKasse);
	     	SendClientMessage(playerid, COLOR_WHITE, String);
	     	format(String,sizeof(String), "  Eingezahlt: %d$",Betrag);
	     	SendClientMessage(playerid, COLOR_WHITE, String);
	     	format(String,sizeof(String), "  Neuer Stand: %d$",NeueFraktionsKasse);
	     	SendClientMessage(playerid, COLOR_WHITE, String);
	     	SendClientMessage(playerid, COLOR_YELLOW, "||---------------------------------------------------||");
	     	return 1;
     	}
     	if(strfind(Abfrage, "auszahlen", true) != -1)
     	{
		 	if(FraktionsKasse<Betrag)return SendClientMessage(playerid,COLOR_DARKRED,"Es ist nicht genug Geld in der Fraktionskasse.");

 			new NeueFraktionsKasse = FraktionsKasse-Betrag;
    	    AntiCheat_GivePlayerMoney(playerid,Betrag);
            FraktionsInfo[FrakID][fKasse]=NeueFraktionsKasse;
    
         	SendClientMessage(playerid, COLOR_YELLOW, "||---------------------------------------------------||");
 	        format(String,sizeof(String), "  Alter Stand: %d$",FraktionsKasse);
 		    SendClientMessage(playerid, COLOR_WHITE, String);
 		    format(String,sizeof(String), "  Ausgezahlt: %d$",Betrag);
 		    SendClientMessage(playerid, COLOR_WHITE, String);
 		    format(String,sizeof(String), "  Neuer Stand: %d$",NeueFraktionsKasse);
 		    SendClientMessage(playerid, COLOR_WHITE, String);
 		    SendClientMessage(playerid, COLOR_YELLOW, "||---------------------------------------------------||");
 		    return 1;
 	    }
	}
	return 1;
}

ocmd:skinchange(playerid)
{
    SpielerInfo[playerid][pSkinauswahl]=1;
    SpielerInfo[playerid][pSkinNummer]=1;
    TogglePlayerSpectating(playerid, true);
    TogglePlayerSpectating(playerid, false);
    TogglePlayerControllable(playerid, false);
    SetPlayerPos(playerid,1738.9098,-1948.2825,14.1172);
    SetPlayerFacingAngle(playerid,177.2759);
    SetPlayerCameraPos(playerid,1738.9277,-1951.4822,14.1172);
    SetPlayerCameraLookAt(playerid,1738.9098,-1948.2825,14.1172);
	
	switch(SpielerInfo[playerid][pFraktion])
    {
        case 1:{SetPlayerSkin(playerid,106);}
        case 2:{SetPlayerSkin(playerid,102);}
        case 3:{SetPlayerSkin(playerid,46);}
        case 4:{SetPlayerSkin(playerid,111);}
        case 5:{SetPlayerSkin(playerid,186);}
        case 6:{SetPlayerSkin(playerid,114);}
        case 7:{SetPlayerSkin(playerid,163);}
        case 8:{SetPlayerSkin(playerid,286);}
        case 9:{SetPlayerSkin(playerid,134);}
        case 10:{SetPlayerSkin(playerid,163);}
        case 11:{SetPlayerSkin(playerid,117);}
        case 12:{SetPlayerSkin(playerid,108);}
        case 13:{SetPlayerSkin(playerid,60);}
        case 14:{SetPlayerSkin(playerid,8);}
        case 15:{SetPlayerSkin(playerid,70);}
        case 16:{SetPlayerSkin(playerid,17);}
    }
    return 1;
}

ocmd:tog(playerid)
{
	new Fraktion[128];
	new Department[128];
	new Offentlich[128];
	new pDialog[612];

	switch(SpielerInfo[playerid][pFchat])
	{
	    case 1:{Fraktion="{FFFFFF}Fraktions Chat {00FF0A}Aktiviert";}
	 	case 0:{Fraktion="{FFFFFF}Fraktions Chat {E10000}Deaktiviert";}
	}
	switch(SpielerInfo[playerid][pDchat])
	{
	    case 1:{Department="{FFFFFF}Department Chat {00FF0A}Aktiviert";}
	 	case 0:{Department="{FFFFFF}Department Chat {E10000}Deaktiviert";}
	}
	switch(SpielerInfo[playerid][pOOC])
	{
	    case 1:{Offentlich="{FFFFFF}Öffentlicher Chat {00FF0A}Aktiviert";}
	 	case 0:{Offentlich="{FFFFFF}Öffentlicher Chat {E10000}Deaktiviert";}
	}

    format(pDialog, sizeof(pDialog), "%s\n%s\n%s\n%s",Fraktion, Department, Offentlich);
   	ShowPlayerDialog(playerid, DIALOG_CHAT, DIALOG_STYLE_LIST, "Chat Menü", pDialog, "Wählen", "Abbrechen");
	return 1;
}

ocmd:o(playerid,params[])
{
    if(OOCServer == 0)return SendClientMessage(playerid,COLOR_DARKRED,"Der OOC Chat ist Deaktiviert!");
    if(SpielerInfo[playerid][pOOC]==0)return SendClientMessage(playerid,COLOR_DARKRED,"Du hast den Öffentlichen Chat Deaktiviert.");
	{
	    if(SpielerInfo[playerid][pMute] != 0)return SendClientMessage(playerid,COLOR_DARKRED,"Du bist gemutet!");
        {
        	new text[300],string[400];
	        if(sscanf(params,"s",text))return SendClientMessage(playerid,COLOR_DARKRED,"/o [Text]");

            for(new i=0; i<GetMaxPlayers(); i++)
        	{
	        	if(IsPlayerConnected(i))
	        	{
		        	if(SpielerInfo[i][pOOC]==1)
		        	{
						if(SpielerInfo[i][pAdminlevel]>=1)
						{
							if(SpielerInfo[i][pAdminUndercover]==0)
							{
                                new arank[64];
                                switch(SpielerInfo[playerid][pAdminlevel])
    	                        {
	                                case 0:{arank="kein Admin";}
	                                case 1:{arank=arank1;}
	                                case 2:{arank=arank2;}
    	                            case 3:{arank=arank3;}
    	                            case 4:{arank=arank4;}
    	                            case 5:{arank=arank5;}
    	                            case 6:{arank=arank6;}
    	                        }
                                format(string,sizeof(string),"(( %s %s: %s ))", arank, SpielerName(playerid),text);
				                SendClientMessage(i,COLOR_DARKBLUE,string);
							}
							else if(SpielerInfo[playerid][pAdminUndercover]==1)
							{
								if(SpielerInfo[playerid][pPremium]==0)
								{
                                    format(string,sizeof(string),"(( %s: %s ))", SpielerName(playerid),text);
				                    SendClientMessage(i,COLOR_WHITE,string);
								}
								else if(SpielerInfo[playerid][pPremium]>=1)
								{
                                    format(string,sizeof(string),"(( Premium User %s: %s ))", SpielerName(playerid),text);
				                    SendClientMessage(i,COLOR_ORANGE,string);
								}
							}
						}
						else if(SpielerInfo[playerid][pAdminlevel]==0)
						{
                            if(SpielerInfo[playerid][pPremium]==0)
							{
                                format(string,sizeof(string),"(( %s: %s ))", SpielerName(playerid),text);
				                SendClientMessage(i,COLOR_WHITE,string);
				        	}
							else if(SpielerInfo[playerid][pPremium]>=1)
							{
                                format(string,sizeof(string),"(( Premium User %s: %s ))", SpielerName(playerid),text);
				                SendClientMessage(i,COLOR_ORANGE,string);
							}
						}
					}
				}
			}
		}
	}
	return 1;
}

ocmd:gangfight(playerid)
{
new FrakID = SpielerInfo[playerid][pFraktion];
new FraktionsKasse = FraktionsInfo[FrakID][fKasse];
if(SpielerInfo[playerid][pStaat]==1)return SendClientMessage(playerid,COLOR_DARKRED,"Du bist in keiner Gang/Mafia!");
if(SpielerInfo[playerid][pFraktion]==9)return SendClientMessage(playerid,COLOR_DARKRED,"Du bist in keiner Gang/Mafia!");
if(SpielerInfo[playerid][pFraktion]==15)return SendClientMessage(playerid,COLOR_DARKRED,"Du bist in keiner Gang/Mafia!");
if(FraktionsKasse >= 50000)return SendClientMessage(playerid,COLOR_DARKRED,"Es ist nicht genug Geld in der Fraktions Kasse!");
if(Gangfight == 1)return SendClientMessage(playerid,COLOR_DARKRED,"Es läuft bereits ein Gangfight!");
new fraktname[64],Str[128];
switch(SpielerInfo[playerid][pFraktion])
{
    case 1:{fraktname=fraktname1;}
    case 2:{fraktname=fraktname2;}
    case 3:{fraktname=fraktname3;}
    case 4:{fraktname=fraktname4;}
    case 5:{fraktname=fraktname5;}
    case 6:{fraktname=fraktname6;}
    case 7:{fraktname=fraktname7;}
    case 8:{fraktname=fraktname8;}
    case 9:{fraktname=fraktname9;}
    case 10:{fraktname=fraktname10;}
    case 11:{fraktname=fraktname11;}
    case 12:{fraktname=fraktname12;}
}
switch(SpielerInfo[playerid][pFraktion])
{
    case 1:{AngreiferFarbe=COLOR_DARKGREEN;}
    case 2:{AngreiferFarbe=COLOR_PINK;}
    case 3:{AngreiferFarbe=COLOR_DARKBLUE;}
    case 4:{AngreiferFarbe=COLOR_GREY;}
    case 5:{AngreiferFarbe=COLOR_WHITE;}
    case 6:{AngreiferFarbe=COLOR_LIGHTBLUE;}
    case 11:{AngreiferFarbe=COLOR_DARKRED;}
    case 12:{AngreiferFarbe=COLOR_YELLOW;}
}

if(IsPlayerInArea(playerid, 2719.0447,-2034.8972, 2815.9976,-1899.4086))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz1)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone1 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz1;
    GangZoneFlashForAll(PlayaDelSeville,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet PlayaDelSeville an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: PlayaDelSeville");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, 2414.0498,-1052.4003, 2626.5676,-936.5402))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz2)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone2 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz2;
    GangZoneFlashForAll(LasColinas,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Las Colinas an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Las Colinas");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, 910.9499,-400.2791, 1132.0104,-272.6128))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz3)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone3 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz3;
    GangZoneFlashForAll(bauernhof,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Bauernhof an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Bauernhof");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, 1119.6848,2709.6711, 1532.9116,2862.4202))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz4)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone4 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz4;
    GangZoneFlashForAll(golf,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Golf Platz an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Golfplatz");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, 2488.9788,2662.8398, 2768.0234,2882.3669))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz5)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone5 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz5;
    GangZoneFlashForAll(mili,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Millitär Gebiet an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Millitär Gebiet");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, -1570.6669,2510.6406, -1295.8569,2755.3601))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz6)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone6 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz6;
    GangZoneFlashForAll(kleinstadt,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Kleinstadt an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Kleinstadt");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, -938.3699,1383.6951, -612.7709,1644.6853))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz7)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone7 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz7;
    GangZoneFlashForAll(tierarobada,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Tiera Robada an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Tiera Robada");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, -1877.8513, 1258.8229, -1736.5641, 1331.0953))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz8)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone8 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz8;
    GangZoneFlashForAll(parkhaus,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet parkhaus an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Parkhaus");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, -2201.4199,-281.7826, -2013.5450,-83.6795))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz9)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone9 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz9;
    GangZoneFlashForAll(indu,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Industrie Gebiet an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Industrie Gebiet");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, -2294.4856,-2578.3203, -1949.9348,-2236.0884))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz10)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone10 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz10;
    GangZoneFlashForAll(AngelPine,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Angel Pine an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Angel Pine");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
else if(IsPlayerInArea(playerid, -5.4260,2422.2090, 422.4625,2598.0898))
{
    if(SpielerInfo[playerid][pFraktion]==GangZonenBesitz11)return SendClientMessage(playerid,COLOR_DARKRED,"Du kannst nicht dein eigenes Gebiet Angreifen!");
    Gangzone11 = 1;
    Gangfight = 1;
    AngreiferCount = 0;
    VerteidigerCount = 5;
    GangfightZeit = 20;
    SetTimer("GangfightTimer",1000*60*20,true);
    Angreifer = SpielerInfo[playerid][pFraktion];
    Verteidiger = GangZonenBesitz11;
    GangZoneFlashForAll(ffh,AngreiferFarbe);
    format(Str,sizeof(Str), "[Gangfight] %s von der Fraktion %s greift das Gebiet Flugzeug Friedhof an.", SpielerName(playerid), fraktname);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }
    TextDrawSetString(Zonentext, "Gebiet: Flugzeug Friedhof");
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
}
return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	//Skinauswahl
	if(newkeys & KEY_JUMP)
	{
        if(IsPlayerConnected(playerid))
        {
			if(SpielerInfo[playerid][pSkinauswahl]==1)
			{
                SpielerInfo[playerid][pSkinNummer]+=1;
				if(SpielerInfo[playerid][pFraktion]==1)//Grove Family
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,106);}
                        case 2:{SetPlayerSkin(playerid,107);}
                        case 3:{SetPlayerSkin(playerid,149);}
                        case 4:{SetPlayerSkin(playerid,269);}
                        case 5:{SetPlayerSkin(playerid,270);}
                        case 6:{SetPlayerSkin(playerid,271);}
                        case 7:{SetPlayerSkin(playerid,65); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==2)//Ballas
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,102);}
                        case 2:{SetPlayerSkin(playerid,103);}
                        case 3:{SetPlayerSkin(playerid,104);}
                        case 4:{SetPlayerSkin(playerid,293);}
                        case 5:{SetPlayerSkin(playerid,13); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==3)//Lcm
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,46);}
                        case 2:{SetPlayerSkin(playerid,47);}
                        case 3:{SetPlayerSkin(playerid,48);}
                        case 4:{SetPlayerSkin(playerid,98);}
                        case 5:{SetPlayerSkin(playerid,223);}
                        case 6:{SetPlayerSkin(playerid,214); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==4)//Russen Mafia
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,111);}
                        case 2:{SetPlayerSkin(playerid,112);}
                        case 3:{SetPlayerSkin(playerid,113);}
                        case 4:{SetPlayerSkin(playerid,124);}
                        case 5:{SetPlayerSkin(playerid,125);}
                        case 6:{SetPlayerSkin(playerid,126);}
                        case 7:{SetPlayerSkin(playerid,272);}
                        case 8:{SetPlayerSkin(playerid,40); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==5)//Yakuza
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,186);}
                        case 2:{SetPlayerSkin(playerid,203);}
                        case 3:{SetPlayerSkin(playerid,204);}
                        case 4:{SetPlayerSkin(playerid,224);}
                        case 5:{SetPlayerSkin(playerid,228);}
                        case 6:{SetPlayerSkin(playerid,169); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==6)//S.F.Rifa
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,114);}
                        case 2:{SetPlayerSkin(playerid,115);}
                        case 3:{SetPlayerSkin(playerid,116);}
                        case 4:{SetPlayerSkin(playerid,173);}
                        case 5:{SetPlayerSkin(playerid,174);}
                        case 6:{SetPlayerSkin(playerid,175);}
                        case 7:{SetPlayerSkin(playerid,273);}
                        case 8:{SetPlayerSkin(playerid,195); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==7)//Ls Officer
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,163);}
                        case 2:{SetPlayerSkin(playerid,164);}
                        case 3:{SetPlayerSkin(playerid,265);}
                        case 4:{SetPlayerSkin(playerid,266);}
                        case 5:{SetPlayerSkin(playerid,267);}
                        case 6:{SetPlayerSkin(playerid,280);}
                        case 7:{SetPlayerSkin(playerid,281); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==8)//Fbi
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,286);}
                        case 2:{SetPlayerSkin(playerid,294);}
                        case 3:{SetPlayerSkin(playerid,165);}
                        case 4:{SetPlayerSkin(playerid,166); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==9)//Hitman
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,134);}
                        case 2:{SetPlayerSkin(playerid,137);}
                        case 3:{SetPlayerSkin(playerid,230);}
                        case 4:{SetPlayerSkin(playerid,234); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
                if(SpielerInfo[playerid][pFraktion]==10)//Lv Officer
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,163);}
                        case 2:{SetPlayerSkin(playerid,164);}
                        case 3:{SetPlayerSkin(playerid,282);}
                        case 4:{SetPlayerSkin(playerid,283);}
                        case 5:{SetPlayerSkin(playerid,288);}
                        case 6:{SetPlayerSkin(playerid,194); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==11)//Triaden
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,117);}
                        case 2:{SetPlayerSkin(playerid,118);}
                        case 3:{SetPlayerSkin(playerid,120);}
                        case 4:{SetPlayerSkin(playerid,208);}
                        case 5:{SetPlayerSkin(playerid,263); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==12)//Ls Vagos
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,108);}
                        case 2:{SetPlayerSkin(playerid,109);}
                        case 3:{SetPlayerSkin(playerid,110);}
                        case 4:{SetPlayerSkin(playerid,91); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==13)//San News
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,60);}
                        case 2:{SetPlayerSkin(playerid,170);}
                        case 3:{SetPlayerSkin(playerid,188);}
                        case 4:{SetPlayerSkin(playerid,227);}
                        case 5:{SetPlayerSkin(playerid,240);}
                        case 6:{SetPlayerSkin(playerid,250);}
                        case 7:{SetPlayerSkin(playerid,56);}
                        case 8:{SetPlayerSkin(playerid,226); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==14)//Ordnungs Amt
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,8);}
                        case 2:{SetPlayerSkin(playerid,50);}
                        case 3:{SetPlayerSkin(playerid,71);}
                        case 4:{SetPlayerSkin(playerid,233); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==15)//Medic
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,70);}
                        case 2:{SetPlayerSkin(playerid,274);}
                        case 3:{SetPlayerSkin(playerid,275);}
                        case 4:{SetPlayerSkin(playerid,276);}
                        case 5:{SetPlayerSkin(playerid,193); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
				if(SpielerInfo[playerid][pFraktion]==16)//Regierung
				{
                    switch(SpielerInfo[playerid][pSkinNummer])
                    {
                        case 1:{SetPlayerSkin(playerid,17);}
                        case 2:{SetPlayerSkin(playerid,147);}
                        case 3:{SetPlayerSkin(playerid,187);}
                        case 4:{SetPlayerSkin(playerid,295);}
                        case 5:{SetPlayerSkin(playerid,12);}
                        case 6:{SetPlayerSkin(playerid,76);}
                        case 7:{SetPlayerSkin(playerid,150);}
                        case 8:{SetPlayerSkin(playerid,219); SpielerInfo[playerid][pSkinNummer]=0;}
                    }
				}
			}
        }
	}
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
        if(IsPlayerConnected(playerid))
        {
			if(SpielerInfo[playerid][pSkinauswahl]==1)
			{
				SpielerInfo[playerid][pSkinauswahl]=0;
                SpielerInfo[playerid][pSkin]=GetPlayerSkin(playerid);
                SpielerInfo[playerid][pSkin]=GetPlayerSkin(playerid);
                SendClientMessage(playerid, COLOR_DARKGREEN, "Du hast erfolgreich deinen Skin geändert.");
                SpawnPlayer(playerid);
			}
        }
	}
	
    //Fraktion und Öffentliche eingänge
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
        if(IsPlayerConnected(playerid))
        {
            for(new i = 0; i < sizeof(PEnter); i++)
            {
                if(IsPlayerInRangeOfPoint(playerid, 2.0, PEnter[i][EnterX], PEnter[i][EnterY], PEnter[i][EnterZ]))
                {
                    SetPlayerPos(playerid, PEnter[i][ExitX], PEnter[i][ExitY], PEnter[i][ExitZ]);
                    SetPlayerInterior(playerid, PEnter[i][Int]);
                    SetPlayerVirtualWorld(playerid, PEnter[i][VW]);
                    break;
                }
                if(IsPlayerInRangeOfPoint(playerid, 2.0, PEnter[i][ExitX], PEnter[i][ExitY], PEnter[i][ExitZ]) && GetPlayerVirtualWorld(playerid) == PEnter[i][VW])
                {
                    SetPlayerPos(playerid, PEnter[i][EnterX], PEnter[i][EnterY], PEnter[i][EnterZ]);
                    SetPlayerInterior(playerid, 0);
                    SetPlayerVirtualWorld(playerid, 0);
                    break;
                }
            }
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid==DIALOG_CHAT)
    {
        if(response==1)
        {
            switch(listitem)
            {
                case 0 :
                {
                    if(SpielerInfo[playerid][pFchat]==1)
                    {
                        SpielerInfo[playerid][pFchat]=0;
                        SendClientMessage(playerid,COLOR_LIGHTBLUE,"Du hast den Fraktions Chat Deaktiviert");
                    }
                    else if(SpielerInfo[playerid][pFchat]==0)
                    {
                        SpielerInfo[playerid][pFchat]=1;
                        SendClientMessage(playerid,COLOR_LIGHTBLUE,"Du hast den Fraktions Chat Aktiviert");
                    }
       	        }
                case 1 :
                {
                    if(SpielerInfo[playerid][pDchat]==1)
                    {
                        SpielerInfo[playerid][pDchat]=0;
                        SendClientMessage(playerid,COLOR_LIGHTBLUE,"Du hast den Department Chat Deaktiviert");
	                }
                    else if(SpielerInfo[playerid][pDchat]==0)
                    {
                        SpielerInfo[playerid][pDchat]=1;
                        SendClientMessage(playerid,COLOR_LIGHTBLUE,"Du hast den Department Chat Aktiviert");
                    }
                }
                case 2 :
                {
                    if(SpielerInfo[playerid][pOOC]==1)
                    {
                        SpielerInfo[playerid][pOOC]=0;
                        SendClientMessage(playerid,COLOR_LIGHTBLUE,"Du hast den Öffentlichen Chat Deaktiviert");
                    }
                    else if(SpielerInfo[playerid][pOOC]==0)
                    {
                        SpielerInfo[playerid][pOOC]=1;
                        SendClientMessage(playerid,COLOR_LIGHTBLUE,"Du hast den Öffentlichen Chat Aktiviert");
                    }
                }
            }
        }
   	}
    if(dialogid == DIALOG_LOGIN)
    {
        if(response)
        {
            if(strlen(inputtext) == 0)
            {
                new Stand = GetPVarInt(playerid,"FalscheLogins");
				SetPVarInt(playerid,"FalscheLogins",Stand+1);

				if(GetPVarInt(playerid,"FalscheLogins")==1)
				{
                    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Das war das Falsche Passwort, Warnung 1/3\nBitte log dich jetzt mit dem richtigen Passwort ein:","Login","Abbrechen");
				}
				if(GetPVarInt(playerid,"FalscheLogins")==2)
				{
                    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Das war das Falsche Passwort, Warnung 2/3\nBitte log dich jetzt mit dem richtigen Passwort ein:","Login","Abbrechen");
				}
				if(GetPVarInt(playerid,"FalscheLogins")==3)
				{
                    SendClientMessage(playerid,COLOR_DARKRED,"Du hast 3 mal dein Passwort falsch eingegeben und wirst daher gekickt.");
                    SetTimerEx("KickTimer", 200,false, "i",playerid);
				}
                return 1;
            }
            else
            {
                new PlayerName[MAX_PLAYER_NAME];
                GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
                if(!strcmp(MD5_Hash(inputtext), mysql_ReturnPasswort(PlayerName), true))
                {
                    SpielerInfo[playerid][pEingelogt]=1;
                    LoadPlayer(playerid);
                    SpawnPlayer(playerid);
                    return 1;
                }
                else
                {
					new Stand = GetPVarInt(playerid,"FalscheLogins");
					SetPVarInt(playerid,"FalscheLogins",Stand+1);

					if(GetPVarInt(playerid,"FalscheLogins")==1)
					{
                        ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Das war das Falsche Passwort, Warnung 1/3\nBitte log dich jetzt mit dem richtigen Passwort ein:","Login","Abbrechen");
	    			}
					if(GetPVarInt(playerid,"FalscheLogins")==2)
					{
                        ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Das war das Falsche Passwort, Warnung 2/3\nBitte log dich jetzt mit dem richtigen Passwort ein:","Login","Abbrechen");
					}
					if(GetPVarInt(playerid,"FalscheLogins")==3)
					{
                        SendClientMessage(playerid,COLOR_DARKRED,"Du hast 3 mal dein Passwort falsch eingegeben und wirst daher gekickt.");
                        SetTimerEx("KickTimer", 200,false, "i",playerid);
					}
					return 1;
                }
            }
        }
        else
        {
            Kick(playerid);
        }
    }
    if(dialogid == DIALOG_REGISTER)
    {
        if(response)
	    {
	        if(strlen(inputtext) == 0)
	        {
	            ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_PASSWORD,"Register Vorgang","Herzlich Willkommen auf den Grean Family Deathmatch Server\nBevor du loslegen kannst musst du dich zuerst registrieren.\nGib bitte dein gewünschtes Passwort an!","Register","Abbrechen"); //... Kommt dieser DIalog
			}
			else
			{
			    CreateAccount(playerid,MD5_Hash(inputtext));
			    SpielerInfo[playerid][pEingelogt]=1;
			    SpawnPlayer(playerid);
			}
		}
    }
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////Stocks////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//MYSQL Fraktion Speichern
stock SaveFraktion(FrakID)
{
    new Fraktion[64];
    switch(FrakID)
    {
        case 1:{Fraktion=fraktname1;}
        case 2:{Fraktion=fraktname2;}
        case 3:{Fraktion=fraktname3;}
        case 4:{Fraktion=fraktname4;}
        case 5:{Fraktion=fraktname5;}
        case 6:{Fraktion=fraktname6;}
        case 7:{Fraktion=fraktname7;}
        case 8:{Fraktion=fraktname8;}
        case 9:{Fraktion=fraktname9;}
        case 10:{Fraktion=fraktname10;}
        case 11:{Fraktion=fraktname11;}
        case 12:{Fraktion=fraktname12;}
        case 13:{Fraktion=fraktname13;}
        case 14:{Fraktion=fraktname14;}
        case 15:{Fraktion=fraktname15;}
        case 16:{Fraktion=fraktname16;}
    }
    
    if(FrakID==1 || FrakID== 2 || FrakID==3 || FrakID==4 || FrakID==5 || FrakID== 6 || FrakID==9 || FrakID==11 || FrakID==12)//Gangs Mafien
    {
        mysql_SetInt("Fraktionen", "Kasse", FraktionsInfo[FrakID][fKasse], "Fraktion", Fraktion);
        mysql_SetInt("Fraktionen", "Members", FraktionsInfo[FrakID][fMembers], "Fraktion", Fraktion);
        mysql_SetInt("Fraktionen", "Fahrzeuge", FraktionsInfo[FrakID][fFahrzeuge], "Fraktion", Fraktion);
        mysql_SetInt("Fraktionen", "Mats", FraktionsInfo[FrakID][fMats], "Fraktion", Fraktion);
	}
  	else if(FrakID==7 || FrakID== 8 || FrakID==10)//Polizei Departments
	{
        mysql_SetInt("StaatsFraktion", "Members", FraktionsInfo[FrakID][fMembers], "Fraktion", Fraktion);
        mysql_SetInt("StaatsFraktion", "Fahrzeuge", FraktionsInfo[FrakID][fFahrzeuge], "Fraktion", Fraktion);
        mysql_SetInt("StaatsFraktion", "Mats", FraktionsInfo[FrakID][fMats], "Fraktion", Fraktion);
	}
	else if(FrakID==13 || FrakID==14 || FrakID==15)//San News, O-Amt, Medik
	{
        mysql_SetInt("StaatsFraktion", "Members", FraktionsInfo[FrakID][fMembers], "Fraktion", Fraktion);
        mysql_SetInt("StaatsFraktion", "Fahrzeuge", FraktionsInfo[FrakID][fFahrzeuge], "Fraktion", Fraktion);
        mysql_SetInt("StaatsFraktion", "Kasse", FraktionsInfo[FrakID][fKasse], "Fraktion", Fraktion);
	}
	else if(FrakID==16)//Regierung
	{
        mysql_SetInt("StaatsFraktion", "Members", FraktionsInfo[FrakID][fMembers], "Fraktion", Fraktion);
        mysql_SetInt("StaatsFraktion", "Fahrzeuge", FraktionsInfo[FrakID][fFahrzeuge], "Fraktion", Fraktion);
        mysql_SetInt("StaatsFraktion", "Mats", FraktionsInfo[FrakID][fMats], "Fraktion", Fraktion);
        mysql_SetInt("StaatsFraktion", "Kasse", FraktionsInfo[FrakID][fKasse], "Fraktion", Fraktion);
	}
	new String[64];
   	format(String,sizeof(String), "Fraktion %s %d$ Kasse Gespeichert",Fraktion, FraktionsInfo[FrakID][fKasse]);
    print(String);

   	format(String,sizeof(String), "Fraktion %s %d Members Gespeichert",Fraktion, FraktionsInfo[FrakID][fMembers]);
    print(String);

    format(String,sizeof(String), "Fraktion %s %d Fahrzeuge Gespeichert",Fraktion, FraktionsInfo[FrakID][fFahrzeuge]);
    print(String);

    format(String,sizeof(String), "Fraktion %s %d Materialien Gespeichert",Fraktion, FraktionsInfo[FrakID][fMats]);
    print(String);
	return 1;
}

//MYSQL Fraktion Laden
stock LoadFraktion(FrakID)
{
    new Fraktion[64];
    switch(FrakID)
    {
        case 1:{Fraktion=fraktname1;}
        case 2:{Fraktion=fraktname2;}
        case 3:{Fraktion=fraktname3;}
        case 4:{Fraktion=fraktname4;}
        case 5:{Fraktion=fraktname5;}
        case 6:{Fraktion=fraktname6;}
        case 7:{Fraktion=fraktname7;}
        case 8:{Fraktion=fraktname8;}
        case 9:{Fraktion=fraktname9;}
        case 10:{Fraktion=fraktname10;}
        case 11:{Fraktion=fraktname11;}
        case 12:{Fraktion=fraktname12;}
        case 13:{Fraktion=fraktname13;}
        case 14:{Fraktion=fraktname14;}
        case 15:{Fraktion=fraktname15;}
        case 16:{Fraktion=fraktname16;}
    }

    if(FrakID==1 || FrakID== 2 || FrakID==3 || FrakID==4 || FrakID==5 || FrakID== 6 || FrakID==9 || FrakID==11 || FrakID==12)//Gangs Mafien
    {
        FraktionsInfo[FrakID][fKasse] = mysql_GetInt("Fraktionen", "Kasse", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fMembers] = mysql_GetInt("Fraktionen", "Members", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fFahrzeuge] = mysql_GetInt("Fraktionen", "Fahrzeuge", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fMats] = mysql_GetInt("Fraktionen", "Mats", "Fraktion", Fraktion);
	}
  	else if(FrakID==7 || FrakID== 8 || FrakID==10)//Polizei Departments
	{
        FraktionsInfo[FrakID][fMembers] = mysql_GetInt("StaatsFraktion", "Members", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fFahrzeuge] = mysql_GetInt("StaatsFraktion", "Fahrzeuge", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fMats] = mysql_GetInt("StaatsFraktion", "Mats", "Fraktion", Fraktion);
	}
	else if(FrakID==13 || FrakID==14 || FrakID==15)//San News, O-Amt, Medik
	{
        FraktionsInfo[FrakID][fKasse] = mysql_GetInt("StaatsFraktion", "Kasse", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fMembers] = mysql_GetInt("StaatsFraktion", "Members", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fFahrzeuge] = mysql_GetInt("StaatsFraktion", "Fahrzeuge", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fMats] = mysql_GetInt("StaatsFraktion", "Mats", "Fraktion", Fraktion);
	}
	else if(FrakID==16)//Regierung
	{
        FraktionsInfo[FrakID][fKasse] = mysql_GetInt("StaatsFraktion", "Kasse", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fMembers] = mysql_GetInt("StaatsFraktion", "Members", "Fraktion", Fraktion);
        FraktionsInfo[FrakID][fFahrzeuge] = mysql_GetInt("StaatsFraktion", "Fahrzeuge", "Fraktion", Fraktion);
	}
    new String[64];
   	format(String,sizeof(String), "Fraktion %s %d$ Kasse Geladen",Fraktion, FraktionsInfo[FrakID][fKasse]);
    print(String);

   	format(String,sizeof(String), "Fraktion %s %d Members Geladen",Fraktion, FraktionsInfo[FrakID][fMembers]);
    print(String);

    format(String,sizeof(String), "Fraktion %s %d Fahrzeuge Geladen",Fraktion, FraktionsInfo[FrakID][fFahrzeuge]);
    print(String);

    format(String,sizeof(String), "Fraktion %s %d Materialien Geladen",Fraktion, FraktionsInfo[FrakID][fMats]);
    print(String);
	return 1;
}

//MYSQL Speichern
stock SavePlayer(playerid)
{
	if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
	    if(SpielerInfo[playerid][pEingelogt] == 1)
	    {
            mysql_SetInt("Users", "Level", GetPlayerScore(playerid), "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Geld", SpielerInfo[playerid][pGeld], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Kills", SpielerInfo[playerid][pKills], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Tode", SpielerInfo[playerid][pTode], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Paket", SpielerInfo[playerid][pPaket], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Warns", SpielerInfo[playerid][pWarns], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Spawn", SpielerInfo[playerid][pSpawn], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Baned", SpielerInfo[playerid][pBaned], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Contract", SpielerInfo[playerid][pContract], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Mute", SpielerInfo[playerid][pMute], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "SupMute", SpielerInfo[playerid][pSupMute], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "TBan", SpielerInfo[playerid][pTBan], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Wanted", SpielerInfo[playerid][pWanted], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Premium", SpielerInfo[playerid][pPremium], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Premiumzeit", SpielerInfo[playerid][pPremiumzeit], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Skin", SpielerInfo[playerid][pSkin], "Name", SpielerInfo[playerid] [pName]);
            mysql_SetInt("Users", "Staat", SpielerInfo[playerid][pStaat], "Name", SpielerInfo[playerid][pName]);
            mysql_SetInt("Users", "Fraktion", SpielerInfo[playerid][pFraktion], "Name", SpielerInfo[playerid] [pName]);
            mysql_SetInt("Users", "Eingelogt", 0, "Name", SpielerInfo[playerid][pName]);
	    }
	}
	return 1;
}

//MYSQL Account Laden
stock LoadPlayer(playerid)
{
	if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
	{
        GetPlayerName(playerid, SpielerInfo[playerid][pName], MAX_PLAYER_NAME);
        SpielerInfo[playerid][pLevel] = mysql_GetInt("Users", "Level", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pGeld] = mysql_GetInt("Users", "Geld", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pKills] = mysql_GetInt("Users", "Kills", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pTode] = mysql_GetInt("Users", "Tode", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pPaket] = mysql_GetInt("Users", "Paket", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pWarns] = mysql_GetInt("Users", "Warns", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pSpawn] = mysql_GetInt("Users", "Spawn", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pBaned] = mysql_GetInt("Users", "Baned", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pContract] = mysql_GetInt("Users", "Contract", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pMute] = mysql_GetInt("Users", "Mute", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pSupMute] = mysql_GetInt("Users", "SupMute", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pTBan] = mysql_GetInt("Users", "TBan", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pWanted] = mysql_GetInt("Users", "Wanted", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pPremium] = mysql_GetInt("Users", "Premium", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pPremiumzeit] = mysql_GetInt("Users", "Premiumzeit", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pAdminlevel] = mysql_GetInt("Users", "Adminlevel", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pSkin] = mysql_GetInt("Users", "Skin", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pStaat] = mysql_GetInt("Users", "Staat", "Name", SpielerInfo[playerid][pName]);
        SpielerInfo[playerid][pFraktion] = mysql_GetInt("Users", "Fraktion", "Name", SpielerInfo[playerid][pName]);
        mysql_SetInt("Users", "Eingelogt", 1, "Name", SpielerInfo[playerid][pName]);
        
        SpielerInfo[playerid][pOOC] = 1;
        SpielerInfo[playerid][pFchat] = 1;
        SpielerInfo[playerid][pDchat] = 1;
        SpielerInfo[playerid][pAdminUndercover] = 1;

		SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");
        SendClientMessage(playerid,COLOR_ORANGE,"           ");

        //Zur Skinauswahl schiken wenn er da noch nicht war
        if(SpielerInfo[playerid][pSkin]==0)
        {
	        SpielerInfo[playerid][pSkinauswahl]=1;
            ForceClassSelection(playerid);
            TogglePlayerSpectating(playerid, true);
            TogglePlayerSpectating(playerid, false);
        }

        if(SpielerInfo[playerid][pPremium]==1)
        {
    		SendClientMessage(playerid, COLOR_ORANGE, "Du hast Permanentes Premium.");
		}
		if(SpielerInfo[playerid][pPremium]==2)
        {
    		new timestamp;
            timestamp = gettime();
            if(SpielerInfo[playerid][pPremiumzeit]>=timestamp)
            {
                new Premiumzeit = SpielerInfo[playerid][pPremiumzeit];
                new diferenz = Premiumzeit - timestamp;
                new alleminuten = diferenz / 60;

                new Tage = alleminuten / 60 / 24;
                new Tagerest = Tage * 24 * 60;
                new Tagerest2 = alleminuten - Tagerest;

                new Stunden = Tagerest2 / 60;
                new Stundenrest = Stunden * 60;
                new Minuten = Tagerest2 - Stundenrest;

                new str[246];
                format(str,sizeof(str),"Du hast noch für %d Tage %d Stunden %d Minuten Premium.", Tage, Stunden, Minuten);
                SendClientMessage(playerid, COLOR_ORANGE, str);
            }
            else if(SpielerInfo[playerid][pPremiumzeit]<=timestamp)
            {
    			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Dein Premium ist abgelaufen.");
				SpielerInfo[playerid][pPremium]=0;
            }
		}

        if(SpielerInfo[playerid][pAdminlevel]>=1)
        {
            SendClientMessage(playerid,COLOR_WHITE,"Nutze {00FF40}/Aduty{FFFFFF} um dich als Admin einzulogen.");
            SendClientMessage(playerid,COLOR_WHITE,"Nutze {00FF40}/Ucaduty {FFFFFF}um dich als Undercover Admin einzulogen.");
            SpielerInfo[playerid][pAdminlevel]=0;
		}

   		if(SpielerInfo[playerid][pBaned]==1)
	    {
            ShowPlayerDialog(playerid, DIALOG_BANN, DIALOG_STYLE_MSGBOX, "Permanenter Bann", "Du wurdest Permanent Gebannt \nfalls du zu unrecht Gebannt wurdest erstell ein Entbann Antrag im Forum.\nForum: www.grean-deathmatch.forumprofi.de", "Beenden", "");
            SetTimerEx("KickTimer", 200,false, "i",playerid);
   	    }

        if(SpielerInfo[playerid][pWarns]==3)
        {
            ShowPlayerDialog(playerid, DIALOG_BANN, DIALOG_STYLE_MSGBOX, "Bann", "Du wurdest Gebannt da du 3/3 Warns hast.\nfalls du zu unrecht Gebannt wurdest erstell ein Entbann Antrag im Forum.\nForum: www.grean-deathmatch.forumprofi.de", "Beenden", "");
	        SetTimerEx("KickTimer", 200,false, "i",playerid);
      	}

		new timestamp;
        timestamp = gettime();
        if(SpielerInfo[playerid][pTBan]>=timestamp)
        {
            new bisgebannt = SpielerInfo[playerid][pTBan];
            new differenz = bisgebannt - timestamp;
            new minuten = differenz / 60;
            new str[246];
            format(str,sizeof(str),"Du bist noch %i Minuten gebannt!\nfalls du zu unrecht Gebannt wurdest erstell ein Entbann Antrag im Forum.\nForum: www.grean-deathmatch.forumprofi.de",minuten);
            ShowPlayerDialog(playerid, DIALOG_BANN, DIALOG_STYLE_MSGBOX, "Time Bann", str, "Beenden", "");
            SetTimerEx("KickTimer", 200,false, "i",playerid);
        }
    }
	return 1;
}

//MYSQL GetString
stock mysql_GetString(Table[], Field[], Where[], Is[])
{
	new query[128], Get[128];
	mysql_real_escape_string(Table, Table);
	mysql_real_escape_string(Field, Field);
	mysql_real_escape_string(Where, Where);
	mysql_real_escape_string(Is, Is);
	format(query, 128, "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", Field, Table, Where, Is);
	mysql_query(query);
	mysql_store_result();
	mysql_fetch_row(Get);
	mysql_free_result();
	return Get;
}

//MYSQL GetInt
stock mysql_GetInt(Table[], Field[], Where[], Is[])
{
    new query[128];
    mysql_real_escape_string(Table, Table);
    mysql_real_escape_string(Field, Field);
    mysql_real_escape_string(Where, Where);
    mysql_real_escape_string(Is, Is);
    format(query, 128, "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", Field, Table, Where, Is);
    mysql_query(query);
    mysql_store_result();
    new sqlint = mysql_fetch_int();
    mysql_free_result();
    return sqlint;
}

//MYSQL Get
stock mysql_Get(Table[], Field[], Where[])
{
    new query[128];
    mysql_real_escape_string(Table, Table);
    mysql_real_escape_string(Field, Field);
    mysql_real_escape_string(Where, Where);
    format(query, 128, "SELECT `%s` FROM `%s` WHERE `%s`", Field, Table, Where);
    mysql_query(query);
    mysql_store_result();
    new sqlint = mysql_fetch_int();
    mysql_free_result();
    return sqlint;
}

//MYSQL SetInt
stock mysql_SetInt(Table[], Field[], To, Where[], Where2[])
{
    new query[128];
    mysql_real_escape_string(Table, Table);
    mysql_real_escape_string(Field, Field);
    mysql_real_escape_string(Where, Where);
    mysql_real_escape_string(Where2, Where2);
    format(query, 128, "UPDATE `%s` SET `%s` = '%d' WHERE `%s` = '%s'", Table, Field, To, Where, Where2);
    mysql_query(query);
    return true;
}

//MYSQL SetString
stock mysql_SetString(Table[], Field[], To[], Where[], Where2[])
{
    new query[128];
    mysql_real_escape_string(Table, Table);
    mysql_real_escape_string(Field, Field);
    mysql_real_escape_string(To, To);
    mysql_real_escape_string(Where, Where);
    mysql_real_escape_string(Where2, Where2);
    format(query, 128, "UPDATE `%s` SET `%s` = '%s' WHERE `%s` = '%s'", Table, Field, To, Where, Where2);
    mysql_query(query);
    return true;
}

//MYSQL SetFloat
stock mysql_SetFloat(Table[], Field[], Float:To, Where[], Where2[])
{
    new query[128];
    mysql_real_escape_string(Table, Table);
    mysql_real_escape_string(Field, Field);
    mysql_real_escape_string(Where, Where);
    mysql_real_escape_string(Where2, Where2);
    format(query, 128, "UPDATE `%s` SET `%s` = '%f' WHERE `%s` = '%s'", Table, Field, To, Where, Where2);
    mysql_query(query);
    return true;
}

//MYSQL GetFloat
stock Float:mysql_GetFloat(Table[], Field[], Where[], Is[])
{
    new query[128], Float:sqlfloat;
    mysql_real_escape_string(Table, Table);
    mysql_real_escape_string(Field, Field);
    mysql_real_escape_string(Where, Where);
    mysql_real_escape_string(Is, Is);
    format(query, 128, "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", Field, Table, Where, Is);
    mysql_query(query);
    mysql_store_result();
    mysql_fetch_float(sqlfloat);
    mysql_free_result();
    return sqlfloat;
}

//MYSQL Account Abfrage
stock mysql_CheckAccount(playerid)
{
	new query[128],name[MAX_PLAYER_NAME],count;
	GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	mysql_real_escape_string(name,name);
	format(query,sizeof(query),"SELECT * FROM `Users` WHERE `Name` = '%s'",SpielerName(playerid));
	mysql_query(query);
	mysql_store_result();
	count = mysql_num_rows();
	mysql_free_result();
	return count;
}

//MYSQL Passwort Abfrage
stock mysql_ReturnPasswort(Name[])
{
    new query[130], Get[130];
    mysql_real_escape_string(Name, Name);
    format(query, 128, "SELECT `Passwort` FROM `Users` WHERE `Name` = '%s'", Name);
    mysql_query(query);
    mysql_store_result();
    mysql_fetch_row(Get);
    mysql_free_result();
    return Get;
}

//MYSQL Register
stock CreateAccount(playerid,key[])
{
	new query[256],name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	mysql_real_escape_string(name,name);
	mysql_real_escape_string(key,key);
	format(query,sizeof(query),"INSERT INTO `Users` (`Name`, `Passwort`) VALUES ('%s','%s')",SpielerName(playerid),key);
	mysql_query(query);
	format(query,sizeof(query),"INSERT INTO `WorldWar` (`Name`) VALUES ('%s')",SpielerName(playerid));
	mysql_query(query);
	SetPVarInt(playerid,"eingelogt",1);
    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"Login","Gib unten dein korrektes Passwort ein!","Login","Abbrechen");
	return true;
}

//MYSQL Connect
stock Connect_To_Database()
{
    mysql_connect(SQL_HOST, SQL_USER, SQL_DATA, SQL_PASS); //Wir versuchen mit den Angaben die wir oben im Script gemacht haben uns mit dem MySQL Server zu verbinden.
    if(mysql_ping() == 1) //Es wird überprüft ob die Verbindung steht.
    {
        //Falls ja wird das in die Console geschrieben und die Funktion wird beendet.
        print("<-| [MYSQL] Verbindung zur Datenbank wurde erfolgreich hergestellt!");
        return true;
    }
    else
    {
        //Falls nicht wird erneut versucht eine Verbindung aufzubauen.
        print("<-| [MYSQL] Es konnte keine Verbindung zur Datenbank hergestellt werden!");
        print("<-| [MYSQL] Es wird erneut versucht eine Verbindung zur Datenbank herzustellen!");
        mysql_connect(SQL_HOST, SQL_USER, SQL_DATA, SQL_PASS);
        if(mysql_ping() == 1)
        {
            print("<-| [MYSQL] Es konnte im 2 Versuch eine Verbindung hergestellt werden!");
            return true;
        }
        else
        {
            //Falls das auch nicht Funktioniert wird der Server zur Sicherheit wieder heruntergefahren.
            print("<-| [MYSQL] Es konnte keine Verbindung zur Datenbank hergestellt werden!");
            print("<-| [MYSQL] Der Server wird nun beendet!");
            SendRconCommand("exit");
            return true;
        }
    }
}

//Stock Geld Serverside
stock AntiCheat_GivePlayerMoney(playerid,Geld)
{
    new GeldStand = SpielerInfo[playerid][pGeld];
    new GeldStatus = GeldStand + Geld;
    SpielerInfo[playerid][pGeld]=GeldStatus;
	return 1;
}

//Stock PayDay Geld
stock GivePlayerPayDay(playerid,Geld)
{
    new pPayDayStand = SpielerInfo[playerid][pPayDay];
    new pPayDayStatus = pPayDayStand + Geld;
    SpielerInfo[playerid][pPayDay]=pPayDayStatus;
	return 1;
}

//Support System
stock UpdateSupportTextdraws()
{
        new Ticketzahl,
        str1[100],
        str2[1000];
        for(new playerid; playerid < GetMaxPlayers(); playerid++)
		{
            if(GetPVarInt(playerid, "Ticketoffen")==1)
		    {
                if(!Ticketzahl)
                    format(str2, sizeof(str2), "%d - %s", playerid, SpielerName(playerid));
                else
                    format(str2, sizeof(str2), "%s~n~%d - %s", str2, playerid, SpielerName(playerid));
                    Ticketzahl++;
                }
        }
        format(str1, sizeof(str1), "%d Ticket(s)", Ticketzahl);
        TextDrawSetString(SupportDraws[1], str2);
        TextDrawSetString(SupportDraws[0], str1);
}

//MYSQL Gangzonen Speichern
stock GangzonenSpeichern()
{
    mysql_SetInt("GangZonen", "GangZone1", GangZonenBesitz1, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone2", GangZonenBesitz2, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone3", GangZonenBesitz3, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone4", GangZonenBesitz4, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone5", GangZonenBesitz5, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone6", GangZonenBesitz6, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone7", GangZonenBesitz7, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone8", GangZonenBesitz8, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone9", GangZonenBesitz9, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone10", GangZonenBesitz10, "ID", "0");
    mysql_SetInt("GangZonen", "GangZone11", GangZonenBesitz11, "ID", "0");
	return 1;
}

//MYSQL Gangzonen Laden
stock GangzonenLaden()
{
    GangZonenBesitz1 = mysql_Get("GangZonen", "Gangzone 1", "Gangzone 1");
	GangZonenBesitz2 = mysql_Get("GangZonen", "Gangzone 2", "Gangzone 2");
	GangZonenBesitz3 = mysql_Get("GangZonen", "Gangzone 3", "Gangzone 3");
	GangZonenBesitz4 = mysql_Get("GangZonen", "Gangzone 4", "Gangzone 4");
	GangZonenBesitz5 = mysql_Get("GangZonen", "Gangzone 5", "Gangzone 5");
	GangZonenBesitz6 = mysql_Get("GangZonen", "Gangzone 6", "Gangzone 6");
	GangZonenBesitz7 = mysql_Get("GangZonen", "Gangzone 7", "Gangzone 7");
	GangZonenBesitz8 = mysql_Get("GangZonen", "Gangzone 8", "Gangzone 8");
	GangZonenBesitz9 = mysql_Get("GangZonen", "Gangzone 9", "Gangzone 9");
	GangZonenBesitz10 = mysql_Get("GangZonen", "Gangzone 10", "Gangzone 10");
	GangZonenBesitz11 = mysql_Get("GangZonen", "Gangzone 11", "Gangzone 11");
	return 1;
}

//GangFight Angreifer Killt Verteidiger
stock GangfightAngreiferKill(killerid, playerid)
{
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }

    new Str[100];
    AngreiferCount+=1;
    format(Str,sizeof(Str), "[Gangfight] %s wurde von %s getötet.",SpielerName(playerid), SpielerName(killerid), AngreiferName, VerteidigerName);
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    GameTextForPlayer(killerid,"~g~Gangzonenkill",2000,3);
    GameTextForPlayer(playerid,"~r~Gangzonentot",2000,3);
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
	return 1;
}

//Gangfight Verteidiger Killt Angreifer
stock GangfightVerteidigerKill(killerid, playerid)
{
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }

    new Str[100];
    VerteidigerCount +=1;
    format(Str,sizeof(Str), "[Gangfight] %s wurde von %s getötet.",SpielerName(playerid), SpielerName(killerid));
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    GameTextForPlayer(killerid,"~g~Gangzonenkill",2000,3);
    GameTextForPlayer(playerid,"~r~Gangzonentot",2000,3);
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
	return 1;
}

//Gangfight Angreifer Killt Angreifer
stock GangfightAngreiferTeamKill(killerid, playerid)
{
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }

    new Str[200];
    VerteidigerCount+=2;
    format(Str,sizeof(Str), "[Gangfight] (Teamkill) %s wurde von %s getötet.",SpielerName(playerid), SpielerName(killerid));
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    GameTextForPlayer(killerid,"~g~Teamkill",2000,3);
    GameTextForPlayer(playerid,"~r~Teamtot",2000,3);
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
	return 1;
}

//Gangfight Verteidiger Killt Verteidiger
stock GangfightVerteidigerTeamKill(killerid, playerid)
{
    new VerteidigerName[64], AngreiferName[64];
    switch(Angreifer)
    {
        case 1:{AngreiferName=fraktname1;}
        case 2:{AngreiferName=fraktname2;}
        case 3:{AngreiferName=fraktname3;}
        case 4:{AngreiferName=fraktname4;}
        case 5:{AngreiferName=fraktname5;}
        case 6:{AngreiferName=fraktname6;}
        case 7:{AngreiferName=fraktname7;}
        case 8:{AngreiferName=fraktname8;}
        case 9:{AngreiferName=fraktname9;}
        case 10:{AngreiferName=fraktname10;}
        case 11:{AngreiferName=fraktname11;}
        case 12:{AngreiferName=fraktname12;}
    }
    switch(Verteidiger)
    {
        case 1:{VerteidigerName=fraktname1;}
        case 2:{VerteidigerName=fraktname2;}
        case 3:{VerteidigerName=fraktname3;}
        case 4:{VerteidigerName=fraktname4;}
        case 5:{VerteidigerName=fraktname5;}
        case 6:{VerteidigerName=fraktname6;}
        case 7:{VerteidigerName=fraktname7;}
        case 8:{VerteidigerName=fraktname8;}
        case 9:{VerteidigerName=fraktname9;}
        case 10:{VerteidigerName=fraktname10;}
        case 11:{VerteidigerName=fraktname11;}
        case 12:{VerteidigerName=fraktname12;}
    }

    new Str[200];
    AngreiferCount +=2;
    format(Str,sizeof(Str), "[Gangfight] (Teamkill) %s wurde von %s getötet.",SpielerName(playerid), SpielerName(killerid));
    SendClientMessageToAll(COLOR_LIGHTBLUE, Str);
    GameTextForPlayer(killerid,"~g~Teamkill",2000,3);
    GameTextForPlayer(playerid,"~r~Teamtot",2000,3);
    new Str4[64];
    new Str2[128];
    new Str3[64];
    format(Str2,sizeof(Str2), "~w~%s: ~b~%d / %d",VerteidigerName, VerteidigerCount, Punktelimit);
    TextDrawSetString(Verteidigertext, Str2);
    format(Str3,sizeof(Str3), "~w~%s: ~b~%d / %d",AngreiferName, AngreiferCount, Punktelimit);
    TextDrawSetString(Angreifertext, Str3);
    format(Str4,sizeof(Str4), "~r~Verbleibende Zeit: %d Minuten",GangfightZeit);
    TextDrawSetString(Zeittext, Str4);
	return 1;
}

//Zonen Abfrage
IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
    new Float:X, Float:Y, Float:Z;

    GetPlayerPos(playerid, X, Y, Z);
    if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) {
        return 1;
    }
    return 0;
}

//SpielerName-Stock
stock SpielerName(playerid)
{
        new GetName[MAX_PLAYER_NAME];
        GetPlayerName(playerid,GetName,sizeof(GetName));
        return GetName;
}

//Random Zahlen
stock GenerateRandomNumber(string[], const length = 8)
{
    for(new i; i < length; ++i)
    {
        string[i] = random(199) + '0';
    }
    return ;
}

//Sscanf
stock sscanf(sstring[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(sstring))
	#else
		if (sstring[0] == 0 || (sstring[0] == 1 && sstring[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		sstringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (sstring[sstringPos] && sstring[sstringPos] <= ' ')
	{
		sstringPos++;
	}
	while (paramPos < paramCount && sstring[sstringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = sstring[sstringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = sstring[++sstringPos];
				}
				do
				{
					sstringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = sstring[sstringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = sstring[sstringPos];
				do
				{
					sstringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = sstring[sstringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, sstring[sstringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = sstringPos;
				while(changepos < 16 && sstring[strpos] && sstring[strpos] != delim)
				{
					changestr[changepos++] = sstring[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(sstring, format[formatPos], false, sstringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				sstringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = sstringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = sstring[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					sstring[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - sstringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, sstring[sstringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					sstring[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				sstringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = sstring[sstringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = sstring[sstringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				sstringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (sstring[sstringPos] && sstring[sstringPos] != delim && sstring[sstringPos] > ' ')
		{
			sstringPos++;
		}
		while (sstring[sstringPos] && (sstring[sstringPos] == delim || sstring[sstringPos] <= ' '))
		{
			sstringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}
