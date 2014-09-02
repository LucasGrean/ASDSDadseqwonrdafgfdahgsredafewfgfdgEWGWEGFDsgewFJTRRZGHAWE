#include <a_samp>

forward CheckForAll();
forward CheckForMeele();
forward CheckForHeavy();
forward CheckForAssault();
forward CheckForLight();
forward CheckForShotgun();
forward CheckForRifle();
forward CheckForRPG();
forward CheckForMinigun();
forward CheckForGrenade();
forward CheckForMolotov();
forward CheckForStatchel();
forward CheckForVision();

public CheckForAll()
{
    SetTimer("AllCheck", 1000, true);
}
public CheckForMeele()
{
    SetTimer("MeeleCheck", 1000, true);
}
public CheckForHeavy()
{
    SetTimer("HeavyCheck", 1000, true);
}
public CheckForAssault()
{
    SetTimer("AssaultCheck", 1000, true);
}
public CheckForLight()
{
    SetTimer("LightCheck", 1000, true);
}
public CheckForShotgun()
{
    SetTimer("ShotgunCheck", 1000, true);
}
public CheckForRifle()
{
    SetTimer("RifleCheck", 1000, true);
}
public CheckForRPG()
{
    SetTimer("RPGCheck", 1000, true);
}
public CheckForMinigun()
{
    SetTimer("MinigunCheck", 1000, true);
}
public CheckForGrenade()
{
    SetTimer("GrenadeCheck", 1000, true);
}
public CheckForMolotov()
{
    SetTimer("MolotovCheck", 1000, true);
}
public CheckForStatchel()
{
    SetTimer("StatchelCheck", 1000, true);
}
public CheckForVision()
{
    SetTimer("VisionCheck", 1000, true);
}

forward AllCheck(playerid);
public AllCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 1) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 2) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 3) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 4) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 5) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 6) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 7) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 8) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 9) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 10) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 11) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 12) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 13) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 14) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 15) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 16) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 17) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 18) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 22) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 23) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 24) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 25) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 26) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 27) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 28) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 29) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 31) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 32) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 33) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 34) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 35) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 36) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 37) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 38) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 39) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 40) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 41) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 42) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 43) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 45) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 46) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 47) Ban(playerid);
    
}
forward MeeleCheck(playerid);
public MeeleCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 1) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 2) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 3) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 4) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 5) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 6) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 7) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 8) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 9) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 10) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 11) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 12) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 13) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 14) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 15) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 41) Ban(playerid);
}
forward HeavyCheck(playerid);
public HeavyCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 9) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 34) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 35) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 36) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 37) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 38) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 39) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 40) Ban(playerid);
}
forward AssaultCheck(playerid);
public AssaultCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 30) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 31) Ban(playerid);
}
forward LightCheck(playerid);
public LightCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 22) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 23) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 24) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 26) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 28) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 29) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 32) Ban(playerid);
}
forward ShotgunCheck(playerid);
public ShotgunCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 25) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 26) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 27) Ban(playerid);
}
forward RifleCheck(playerid);
public RifleCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 33) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 34) Ban(playerid);
}
forward RPGCheck(playerid);
public RPGCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 35) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 36) Ban(playerid);
}
forward StatchelCheck(playerid);
public StatchelCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 39) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 40) Ban(playerid);
}
forward VisionCheck(playerid);
public VisionCheck(playerid)
{
    if(GetPlayerWeapon(playerid) == 44) Ban(playerid);
    if(GetPlayerWeapon(playerid) == 45) Ban(playerid);
}

