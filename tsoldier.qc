//=-=-=-=-=
void () NailGrenadeExplode;
void () NailGrenadeNailEm;
void () NailGrenadeLaunchNail;

void () NailGrenadeTouch =
{
	if ((other == self.owner))
	{
		return;
	}
	sound (self, 1, "weapons/bounce.wav", 1, 1);
	if ((self.velocity == '0 0 0'))
	{
		self.avelocity = '0 0 0';
	}
};

void () NailGrenadeExplode =
{
	local entity te;

	self.owner.no_active_nail_grens = (self.owner.no_active_nail_grens + 1);
	if ((self.owner.no_active_nail_grens > 0))
	{
		te = find (world, classname, "grenade");
		while (te)
		{
			if (((te.owner == self.owner) && (te.no_active_nail_grens == 1)))
			{
				te.weapon = 9;
				te.think = GrenadeExplode;
				te.nextthink = (time + 0.1);
			}
			te = find (te, classname, "grenade");
		}
	}
	self.no_active_nail_grens = self.owner.no_active_nail_grens;
	self.movetype = 5;
	setorigin (self, (self.origin + '0 0 32'));
	self.avelocity = '0 500 0';
	self.nextthink = (time + 0.7);
	self.think = NailGrenadeNailEm;
};

void () NailGrenadeNailEm =
{
	self.velocity = '0 0 0';
	if (shortergrens)
		self.nextthink = (time + 0.07);
	else
		self.nextthink = (time + 0.1);
	self.think = NailGrenadeLaunchNail;
	self.playerclass = 0;
};

void () NailGrenadeLaunchNail =
{
	local float i;
	local float j;
	local float cur_yaw;

	i = 0;
	while ((i < 3))
	{
		j = ((random () + 2) * 5);
		cur_yaw = anglemod ((self.angles_y + j));
		self.angles_y = cur_yaw;
		self.angles_x = 0;
		self.angles_z = 0;
		makevectors (self.angles);
		deathmsg = 9;
		launch_spike (self.origin, v_forward);
		newmis.touch = superspike_touch;
		newmis.weapon = 9;
		i = (i + 1);
	}
	self.playerclass = (self.playerclass + 1);
	if (shortergrens)
		self.nextthink = (time + 0.07);
	else
		self.nextthink = (time + 0.1);

	if ((self.playerclass > _2))
	{
		self.weapon = 9;
		self.think = GrenadeExplode;
	}
};
