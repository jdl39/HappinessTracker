# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

userdata = [
	{'email' => 'non.enim.Mauris@Suspendisse.edu', 'first_name' => 'Xandra', 'last_name' => 'Martinez', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'XandraMartinez'},
	{'email' => 'a@gmail.com', 'first_name' => 'a', 'last_name' => 'a', 'password' => 'a', 'password_confirmation' => 'a', 'username' => 'a'},
	{'email' => 'sit.amet@iaculislacuspede.net', 'first_name' => 'Alec', 'last_name' => 'Donaldson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AlecDonaldson'},
	{'email' => 'tristique.neque.venenatis@semperNamtempor.co.uk', 'first_name' => 'Price', 'last_name' => 'Kelley', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'PriceKelley'},
	{'email' => 'vitae.aliquam@molestie.org', 'first_name' => 'Slade', 'last_name' => 'Rojas', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'SladeRojas'},
	{'email' => 'bibendum.Donec@atortor.ca', 'first_name' => 'Brent', 'last_name' => 'Bishop', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'BrentBishop'},
	{'email' => 'orci@idsapienCras.net', 'first_name' => 'Otto', 'last_name' => 'Shepherd', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'OttoShepherd'},
	{'email' => 'sagittis@ipsumdolorsit.ca', 'first_name' => 'Armand', 'last_name' => 'Sosa', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ArmandSosa'},
	{'email' => 'accumsan@lacus.ca', 'first_name' => 'Dillon', 'last_name' => 'Alston', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'DillonAlston'},
	{'email' => 'vehicula.aliquet.libero@tortordictumeu.net', 'first_name' => 'Amery', 'last_name' => 'Brown', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AmeryBrown'},
	{'email' => 'ultrices.sit@dolor.net', 'first_name' => 'Maxine', 'last_name' => 'Morrison', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'MaxineMorrison'},
	{'email' => 'tincidunt@quamPellentesquehabitant.co.uk', 'first_name' => 'Gloria', 'last_name' => 'Willis', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'GloriaWillis'},
	{'email' => 'est.congue@a.edu', 'first_name' => 'Zenaida', 'last_name' => 'Roberson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ZenaidaRoberson'},
	{'email' => 'consectetuer.adipiscing@amet.ca', 'first_name' => 'Troy', 'last_name' => 'Short', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'TroyShort'},
	{'email' => 'Suspendisse.tristique.neque@Suspendisseacmetus.edu', 'first_name' => 'Nathaniel', 'last_name' => 'Sweet', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'NathanielSweet'},
	{'email' => 'sociis.natoque.penatibus@Donec.net', 'first_name' => 'Vielka', 'last_name' => 'Blevins', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'VielkaBlevins'},
	{'email' => 'enim@ridiculusmus.ca', 'first_name' => 'Orson', 'last_name' => 'Salinas', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'OrsonSalinas'},
	{'email' => 'natoque@pharetrafelis.org', 'first_name' => 'Ignatius', 'last_name' => 'Barrett', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'IgnatiusBarrett'},
	{'email' => 'vulputate.lacus@aliquetmagna.edu', 'first_name' => 'Jerome', 'last_name' => 'Young', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'JeromeYoung'},
	{'email' => 'a.aliquet@temporaugue.ca', 'first_name' => 'Genevieve', 'last_name' => 'Hopkins', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'GenevieveHopkins'},
	{'email' => 'sem.consequat@aceleifendvitae.co.uk', 'first_name' => 'Alvin', 'last_name' => 'Gross', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AlvinGross'},
	{'email' => 'Duis.gravida.Praesent@natoque.net', 'first_name' => 'Jena', 'last_name' => 'Larson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'JenaLarson'},
	{'email' => 'enim.condimentum.eget@in.ca', 'first_name' => 'Brennan', 'last_name' => 'Higgins', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'BrennanHiggins'},
	{'email' => 'Suspendisse.ac@ametdiam.com', 'first_name' => 'Yolanda', 'last_name' => 'Merrill', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'YolandaMerrill'},
	{'email' => 'urna.Nullam@Duis.edu', 'first_name' => 'Damon', 'last_name' => 'White', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'DamonWhite'},
	{'email' => 'nulla@Nam.com', 'first_name' => 'Rhiannon', 'last_name' => 'Delaney', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'RhiannonDelaney'},
	{'email' => 'Vivamus@pretium.net', 'first_name' => 'Abdul', 'last_name' => 'Cooley', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AbdulCooley'},
	{'email' => 'sem.ut@anequeNullam.ca', 'first_name' => 'Lee', 'last_name' => 'Horton', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'LeeHorton'},
	{'email' => 'fermentum.fermentum.arcu@consequatdolor.net', 'first_name' => 'Jane', 'last_name' => 'Gibson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'JaneGibson'},
	{'email' => 'nec@telluslorem.ca', 'first_name' => 'Paloma', 'last_name' => 'Reilly', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'PalomaReilly'},
	{'email' => 'tellus.Aenean@Praesenteu.co.uk', 'first_name' => 'Galena', 'last_name' => 'Frye', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'GalenaFrye'},
	{'email' => 'euismod@malesuadamalesuadaInteger.ca', 'first_name' => 'Lucian', 'last_name' => 'Black', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'LucianBlack'},
	{'email' => 'orci.lobortis.augue@mollisnon.ca', 'first_name' => 'Byron', 'last_name' => 'Richmond', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ByronRichmond'},
	{'email' => 'ac.orci.Ut@sedsemegestas.edu', 'first_name' => 'Kellie', 'last_name' => 'Mayer', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'KellieMayer'},
	{'email' => 'in@magnaSuspendissetristique.co.uk', 'first_name' => 'Melinda', 'last_name' => 'Tyson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'MelindaTyson'},
	{'email' => 'neque@lacusNullatincidunt.ca', 'first_name' => 'Barry', 'last_name' => 'Lester', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'BarryLester'},
	{'email' => 'ante@ligulaNullamenim.edu', 'first_name' => 'Ciara', 'last_name' => 'Poole', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'CiaraPoole'},
	{'email' => 'convallis@pharetra.net', 'first_name' => 'Sheila', 'last_name' => 'Brown', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'SheilaBrown'},
	{'email' => 'Pellentesque@egetmetuseu.org', 'first_name' => 'Wayne', 'last_name' => 'Kim', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'WayneKim'},
	{'email' => 'augue.ac@mifringillami.edu', 'first_name' => 'Aurora', 'last_name' => 'Church', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AuroraChurch'},
	{'email' => 'semper.Nam@ultricessit.ca', 'first_name' => 'Aristotle', 'last_name' => 'Gentry', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AristotleGentry'},
	{'email' => 'pede.Suspendisse.dui@elementumategestas.edu', 'first_name' => 'Chava', 'last_name' => 'Bernard', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ChavaBernard'},
	{'email' => 'malesuada.fringilla.est@adipiscing.org', 'first_name' => 'Emerald', 'last_name' => 'Chase', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'EmeraldChase'},
	{'email' => 'sit.amet.consectetuer@eleifendvitaeerat.com', 'first_name' => 'Claudia', 'last_name' => 'Harrell', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ClaudiaHarrell'},
	{'email' => 'id.mollis@velit.co.uk', 'first_name' => 'Caleb', 'last_name' => 'Stevenson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'CalebStevenson'},
	{'email' => 'pellentesque@egestas.org', 'first_name' => 'Hannah', 'last_name' => 'Garrett', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'HannahGarrett'},
	{'email' => 'eu.sem@mattissemper.ca', 'first_name' => 'Callie', 'last_name' => 'Gay', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'CallieGay'},
	{'email' => 'eget@semper.net', 'first_name' => 'Nero', 'last_name' => 'Christian', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'NeroChristian'},
	{'email' => 'et.arcu.imperdiet@pellentesqueegetdictum.edu', 'first_name' => 'Naida', 'last_name' => 'Kelly', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'NaidaKelly'},
	{'email' => 'lectus@vitae.net', 'first_name' => 'Raven', 'last_name' => 'Larson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'RavenLarson'},
	{'email' => 'mattis@disparturient.edu', 'first_name' => 'Sawyer', 'last_name' => 'Allison', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'SawyerAllison'},
	{'email' => 'pede.malesuada.vel@vulputatenisi.net', 'first_name' => 'Allistair', 'last_name' => 'Simon', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AllistairSimon'},
	{'email' => 'turpis.Aliquam@vel.net', 'first_name' => 'Shelby', 'last_name' => 'Hill', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ShelbyHill'},
	{'email' => 'nibh.Quisque@metus.org', 'first_name' => 'Venus', 'last_name' => 'Tate', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'VenusTate'},
	{'email' => 'gravida.nunc.sed@diamDuis.co.uk', 'first_name' => 'Paki', 'last_name' => 'Bentley', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'PakiBentley'},
	{'email' => 'et.netus@a.edu', 'first_name' => 'Ginger', 'last_name' => 'Hester', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'GingerHester'},
	{'email' => 'tortor.nibh.sit@consectetuerrhoncusNullam.ca', 'first_name' => 'Nomlanga', 'last_name' => 'Waters', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'NomlangaWaters'},
	{'email' => 'gravida.Praesent@euaugue.net', 'first_name' => 'Kirsten', 'last_name' => 'Erickson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'KirstenErickson'},
	{'email' => 'Integer.eu@Proin.ca', 'first_name' => 'Stacey', 'last_name' => 'Garza', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'StaceyGarza'},
	{'email' => 'turpis.In@fringilla.edu', 'first_name' => 'Lyle', 'last_name' => 'Koch', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'LyleKoch'},
	{'email' => 'non.dui@orci.org', 'first_name' => 'Erin', 'last_name' => 'Wilkins', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ErinWilkins'},
	{'email' => 'Suspendisse.ac.metus@necdiam.edu', 'first_name' => 'Julian', 'last_name' => 'Mathis', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'JulianMathis'},
	{'email' => 'tempus.eu@leo.org', 'first_name' => 'Joan', 'last_name' => 'Clay', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'JoanClay'},
	{'email' => 'a.tortor.Nunc@aliquetProinvelit.net', 'first_name' => 'Maris', 'last_name' => 'Christensen', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'MarisChristensen'},
	{'email' => 'Etiam.ligula@nunc.org', 'first_name' => 'Travis', 'last_name' => 'Davis', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'TravisDavis'},
	{'email' => 'Nunc.ullamcorper.velit@Quisque.com', 'first_name' => 'Tashya', 'last_name' => 'Manning', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'TashyaManning'},
	{'email' => 'ut.quam.vel@Cras.com', 'first_name' => 'Kylan', 'last_name' => 'Emerson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'KylanEmerson'},
	{'email' => 'posuere@egettincidunt.net', 'first_name' => 'Elijah', 'last_name' => 'Cardenas', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ElijahCardenas'},
	{'email' => 'quis@mipede.org', 'first_name' => 'Ulric', 'last_name' => 'Hull', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'UlricHull'},
	{'email' => 'pede.Nunc@in.org', 'first_name' => 'Barclay', 'last_name' => 'Brennan', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'BarclayBrennan'},
	{'email' => 'Pellentesque.tincidunt.tempus@dui.co.uk', 'first_name' => 'Kiona', 'last_name' => 'Phelps', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'KionaPhelps'},
	{'email' => 'non.magna@vestibulumnec.org', 'first_name' => 'Keefe', 'last_name' => 'Holden', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'KeefeHolden'},
	{'email' => 'massa.lobortis@milaciniamattis.co.uk', 'first_name' => 'Savannah', 'last_name' => 'Bennett', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'SavannahBennett'},
	{'email' => 'pharetra.ut.pharetra@porttitortellusnon.co.uk', 'first_name' => 'Isabella', 'last_name' => 'Howe', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'IsabellaHowe'},
	{'email' => 'ipsum.dolor@tempus.edu', 'first_name' => 'Kylee', 'last_name' => 'Weber', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'KyleeWeber'},
	{'email' => 'nec.quam@viverraDonectempus.org', 'first_name' => 'Lane', 'last_name' => 'Gross', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'LaneGross'},
	{'email' => 'nunc@ipsum.net', 'first_name' => 'Forrest', 'last_name' => 'Henson', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ForrestHenson'},
	{'email' => 'nibh@egetmetusIn.co.uk', 'first_name' => 'Gregory', 'last_name' => 'Blanchard', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'GregoryBlanchard'},
	{'email' => 'pellentesque.a@euismod.co.uk', 'first_name' => 'Veronica', 'last_name' => 'Britt', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'VeronicaBritt'},
	{'email' => 'nisi@cursus.com', 'first_name' => 'Veda', 'last_name' => 'Moody', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'VedaMoody'},
	{'email' => 'in.faucibus@Donec.com', 'first_name' => 'Heidi', 'last_name' => 'Browning', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'HeidiBrowning'},
	{'email' => 'turpis.vitae@inlobortistellus.ca', 'first_name' => 'Yolanda', 'last_name' => 'Boyle', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'YolandaBoyle'},
	{'email' => 'consectetuer.adipiscing.elit@massaQuisqueporttitor.co.uk', 'first_name' => 'Aquila', 'last_name' => 'Lee', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'AquilaLee'},
	{'email' => 'arcu.Morbi.sit@Aeneansedpede.edu', 'first_name' => 'Colt', 'last_name' => 'Austin', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ColtAustin'},
	{'email' => 'arcu.imperdiet@tellusjusto.ca', 'first_name' => 'Quintessa', 'last_name' => 'Logan', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'QuintessaLogan'},
	{'email' => 'metus.In.lorem@arcuVestibulumante.ca', 'first_name' => 'Malcolm', 'last_name' => 'Blake', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'MalcolmBlake'},
	{'email' => 'nisl.arcu@ac.ca', 'first_name' => 'Nicholas', 'last_name' => 'Workman', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'NicholasWorkman'},
	{'email' => 'parturient.montes@at.net', 'first_name' => 'Brooke', 'last_name' => 'Hooper', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'BrookeHooper'},
	{'email' => 'facilisis.magna.tellus@vehicularisus.ca', 'first_name' => 'Clare', 'last_name' => 'Oneal', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'ClareOneal'},
	{'email' => 'dis.parturient@tincidunt.edu', 'first_name' => 'Buffy', 'last_name' => 'Moreno', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'BuffyMoreno'},
	{'email' => 'Mauris.eu.turpis@variuset.net', 'first_name' => 'Germaine', 'last_name' => 'Parrish', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'GermaineParrish'},
	{'email' => 'dictum.eu.eleifend@velitin.com', 'first_name' => 'Mikayla', 'last_name' => 'Rush', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'MikaylaRush'},
	{'email' => 'nibh.lacinia@at.net', 'first_name' => 'Hector', 'last_name' => 'Garrett', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'HectorGarrett'},
	{'email' => 'Donec@odio.edu', 'first_name' => 'Price', 'last_name' => 'Page', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'PricePage'},
	{'email' => 'Cras.dictum.ultricies@eunulla.edu', 'first_name' => 'Rama', 'last_name' => 'Robbins', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'RamaRobbins'},
	{'email' => 'blandit.viverra@id.net', 'first_name' => 'Cynthia', 'last_name' => 'Clemons', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'CynthiaClemons'},
	{'email' => 'erat.neque.non@atiaculisquis.ca', 'first_name' => 'Duncan', 'last_name' => 'Black', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'DuncanBlack'},
	{'email' => 'Aliquam@ridiculusmusDonec.com', 'first_name' => 'Lynn', 'last_name' => 'Crane', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'LynnCrane'},
	{'email' => 'Nulla.facilisi.Sed@nectempusscelerisque.org', 'first_name' => 'Cedric', 'last_name' => 'Leblanc', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'CedricLeblanc'},
	{'email' => 'non.massa@nibhPhasellus.org', 'first_name' => 'Ferdinand', 'last_name' => 'Mccullough', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'FerdinandMccullough'},
	{'email' => 'fermentum@mauris.ca', 'first_name' => 'Janna', 'last_name' => 'Allen', 'password' => 'password', 'password_confirmation' => 'password', 'username' => 'JannaAllen'}
];

for datum in userdata do
	user = User.create(email: datum['email'], first_name: datum['first_name'],
		last_name: datum['last_name'], password: datum['password'],
		password_confirmation: datum['password_confirmation'], username: datum['username'])
end

activity_type_data = [
	{'name' => 'running'},
	{'name' => 'reading'},
	{'name' => 'meditation'},
	{'name' => 'hanging out with friends'},
	{'name' => 'mindful eating'},
	{'name' => 'weight lifting'},
	{'name' => 'playing guitar'},
	{'name' => 'singing'},
	{'name' => 'acting for theater'},
	{'name' => 'acting for film'},
	{'name' => 'playing video games'},
	{'name' => 'reading comic books'},
	{'name' => 'jogging'},
	{'name' => 'playing pool'},
	{'name' => 'swimming'},
	{'name' => 'practicing piano'},
	{'name' => 'practicing violin'},
	{'name' => 'archery'},
	{'name' => 'bowling'},
	{'name' => 'helping strangers'},
	{'name' => 'giving gifts'},
	{'name' => 'threw a party'},
	{'name' => 'organized a social event'},
	{'name' => 'organizing'},
	{'name' => 'cleaning'},
	{'name' => 'giving alms'},
	{'name' => 'prayer'},
	{'name' => 'laughter'},
	{'name' => 'making others laugh'},
	{'name' => 'biking'},
	{'name' => 'mountain climbing'},
	{'name' => 'hiking'},
	{'name' => 'climbing'},
	{'name' => 'exercise'},
	{'name' => 'sit-ups'},
	{'name' => 'pull-ups'},
	{'name' => 'crunches'},
	{'name' => 'watching television'},
	{'name' => 'watching television with family'},
	{'name' => 'giving thanks'},
	{'name' => 'writing letters'},
	{'name' => 'gratitude text'},
	{'name' => 'calling loved ones'},
	{'name' => 'spending time outside'},
	{'name' => 'going for walks'},
	{'name' => 'chores'},
	{'name' => 'made work enjoyable'},
	{'name' => 'tennis'},
	{'name' => 'ping pong'},
	{'name' => 'creative writing'},
	{'name' => 'writing articles'},
	{'name' => 'diary'},
	{'name' => 'remembered dreams'},
	{'name' => 'lucid dreaming'},
]

lemmatizer = Lemmatizer.new
for datum in activity_type_data do
	type = ActivityType.create(name: datum['name'].downcase, num_users: 0)
    datum['name'].split.each{|word| ActivityWord.create(word: word, activity_type: type)}
    datum['name'].split.each{|word| ActivityWord.create(word: lemmatizer.lemma(word), activity_type: type)}
end

measurement_type_data = [
    {'is_quantifiable' => false, 'name' => ''},
    {'is_quantifiable' => true, 'name' => 'miles'},
    {'is_quantifiable' => true, 'name' => 'kilometers'},
    {'is_quantifiable' => true, 'name' => 'reps'},
    {'is_quantifiable' => true, 'name' => 'sets'},
    {'is_quantifiable' => true, 'name' => 'seconds'},
    {'is_quantifiable' => true, 'name' => 'minutes'},
    {'is_quantifiable' => true, 'name' => 'hours'},
    {'is_quantifiable' => true, 'name' => 'pages'},
    {'is_quantifiable' => true, 'name' => 'songs'},
    {'is_quantifiable' => true, 'name' => 'calories'},
    {'is_quantifiable' => true, 'name' => 'matches'},
    {'is_quantifiable' => true, 'name' => 'rounds'},
    {'is_quantifiable' => true, 'name' => 'issues'},
]

for datum in measurement_type_data do
    MeasurementType.create(name: datum['name'].downcase, is_quantifiable: datum['is_quantifiable']) 
end

activity_data = [
	{'user' => User.find(1), 'activity_type' => ActivityType.find_by(name: 'running'), 'measurement_types' => MeasurementType.where(name: ['miles','minutes'])},
	{'user' => User.find(1), 'activity_type' => ActivityType.find_by(name: 'weight lifting'), 'measurement_types' => MeasurementType.where(name: 'sets')},
	{'user' => User.find(1), 'activity_type' => ActivityType.find_by(name: 'hanging out with friends'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(1), 'activity_type' => ActivityType.find_by(name: 'reading'), 'measurement_types' => MeasurementType.where(name: 'pages')},
	{'user' => User.find(2), 'activity_type' => ActivityType.find_by(name: 'meditation'), 'measurement_types' => MeasurementType.where(name: 'minutes')},
	{'user' => User.find(2), 'activity_type' => ActivityType.find_by(name: 'mindful eating'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(2), 'activity_type' => ActivityType.find_by(name: 'playing guitar'), 'measurement_types' => MeasurementType.where(name: 'songs')},
	{'user' => User.find(2), 'activity_type' => ActivityType.find_by(name: 'reading'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(3), 'activity_type' => ActivityType.find_by(name: 'playing guitar'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(3), 'activity_type' => ActivityType.find_by(name: 'singing'), 'measurement_types' => MeasurementType.where(name: 'minutes')},
	{'user' => User.find(3), 'activity_type' => ActivityType.find_by(name: 'acting for theater'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(3), 'activity_type' => ActivityType.find_by(name: 'acting for film'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(4), 'activity_type' => ActivityType.find_by(name: 'hanging out with friends'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(4), 'activity_type' => ActivityType.find_by(name: 'playing video games'), 'measurement_types' => MeasurementType.where(name: 'matches')},
	{'user' => User.find(4), 'activity_type' => ActivityType.find_by(name: 'reading comic books'), 'measurement_types' => MeasurementType.where(name: 'issues')},
	{'user' => User.find(4), 'activity_type' => ActivityType.find_by(name: 'playing guitar'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(5), 'activity_type' => ActivityType.find_by(name: 'meditation'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(5), 'activity_type' => ActivityType.find_by(name: 'running'), 'measurement_types' => MeasurementType.where(name: ['kilometers', 'minutes'])},
	{'user' => User.find(5), 'activity_type' => ActivityType.find_by(name: 'reading'), 'measurement_types' => MeasurementType.where(name: '')},
	{'user' => User.find(5), 'activity_type' => ActivityType.find_by(name: 'singing'), 'measurement_types' => MeasurementType.where(name: 'songs')},
]

for datum in activity_data do
	puts "Activity: " + datum['user'].username + "+" + datum['activity_type'].name
	datum['activity_type'].reload
	act = Activity.new
	act.user = datum['user']
	act.activity_type = datum['activity_type']
    act.measurement_types = datum['measurement_types']
	datum['activity_type'].update_attribute(:num_users, datum['activity_type'].num_users + 1)
	act.save
end

measure_data = [
    {'value' => 1, 'measurement_type_id' => 1, 'activity_id' => 1}
]

happiness_question_data = [
	{'content' => "In general, how happy do you consider yourself?", 'max_score' => 6},
	{'content' => "How happy are you compared to your peers?", 'max_score' => 6},
	{'content' => "Some people are generally very happy. They enjoy life regardless of their circumstances. How much do you feel this describes you?", 'max_score' => 6},
	{'content' => "How pleased are you with yourself?", 'max_score' => 6},
	{'content' => "How intensely interested are you in other people?", 'max_score' => 6},
	{'content' => "How much do you feel that life is rewarding?", 'max_score' => 6},
	{'content' => "How much do you have warm feelings towards everyone?", 'max_score' => 6},
	{'content' => "How often do you wake up feeling rested?", 'max_score' => 6},
	{'content' => "How optimistic are you about the future?", 'max_score' => 6},
	{'content' => "How often do you find things in your life amusing?", 'max_score' => 6},
	{'content' => "How committed and involved are you?", 'max_score' => 6},
	{'content' => "How much would you say life is good?", 'max_score' => 6},
	{'content' => "How much do you feel that the world is a good place?", 'max_score' => 6},
	{'content' => "How often do you laugh?", 'max_score' => 6},
	{'content' => "How satisfied are you with everything in your life?", 'max_score' => 6},
	{'content' => "How attractive do you think you look?", 'max_score' => 6},
	{'content' => "How much of what you would like to do have you done?", 'max_score' => 6},
	{'content' => "How happy are you?", 'max_score' => 6},
	{'content' => "How often do you find beauty in things?", 'max_score' => 6},
	{'content' => "How cheerful of an effect do you have on others?", 'max_score' => 6},
	{'content' => "Can you find time for everything you want to do?", 'max_score' => 6},
	{'content' => "How much control do you feel you have in your life?", 'max_score' => 6},
	{'content' => "How much do you feel that you can take anything on?", 'max_score' => 6},
	{'content' => "How much do you feel fully mentally alert?", 'max_score' => 6},
	{'content' => "How often do you experience joy and elation?", 'max_score' => 6},
	{'content' => "How easy do you find it to make decisions?", 'max_score' => 6},
	{'content' => "How much of a sense of meaning and purpose do you have in your life?", 'max_score' => 6},
	{'content' => "How much do you feel that you have a great deal of energy?", 'max_score' => 6},
	{'content' => "How often do you have a positive influence on events?", 'max_score' => 6},
	{'content' => "How much fun do you have with other people?", 'max_score' => 6},
	{'content' => "How healthy do you feel?", 'max_score' => 6},
	{'content' => "How many happy memories do you have of the past?", 'max_score' => 6},
]

frienddata = [
	{'user_id' => 1, 'friend_id' => 2},
	{'user_id' => 2, 'friend_id' => 1},
	{'user_id' => 1, 'friend_id' => 3},
	{'user_id' => 3, 'friend_id' => 1},
	{'user_id' => 2, 'friend_id' => 3},
	{'user_id' => 3, 'friend_id' => 2},
]

for friend in frienddata do
    puts "Friends: " + User.find(friend['user_id']).username + "+" + User.find(friend['friend_id']).username
    Friend.create(friend)
end

messagedata = [ 
	    {'sender_id' => 1, 'receiver_id' => 2, 'content'=> 'hi'}, 
		{'sender_id' => 1, 'receiver_id' => 3, 'content'=> 'yo'}, 
	    {'sender_id' => 2, 'receiver_id' => 3, 'content'=> 'bye'}, 
]

for message in messagedata do
    puts "Message: " + User.find(message['sender_id']).username + " to " + User.find(message['receiver_id']).username
    Message.create(message)
end


challengedata = [ 
	    {'sender_id' => 1, 'receiver_id' => 2, 'content'=> 'Eat a banana!'}, 
		{'sender_id' => 1, 'receiver_id' => 3, 'content'=> 'Buy food!'}, 
	    {'sender_id' => 2, 'receiver_id' => 3, 'content'=> 'Play the guitar!'}, 
]

for challenge in challengedata do
    puts "Challenge: " + User.find(message['sender_id']).username + " to " + User.find(message['receiver_id']).username
    Challenge.create(challenge)
end

for steffee in happiness_question_data do
	puts "Happiness Question: " + steffee['content']
	q = HappinessQuestion.new
	q.content = steffee['content']
	q.max_score = steffee['max_score']
	q.save
end

hc_general = HappinessCategory.new
hc_general.name = "General"
hc_general.save
hc_general.happiness_questions << HappinessQuestion.find(1)
hc_general.happiness_questions << HappinessQuestion.find(2)
hc_general.happiness_questions << HappinessQuestion.find(3)
hc_general.happiness_questions << HappinessQuestion.find(18)
hc_general.happiness_questions << HappinessQuestion.find(25)

hc_social = HappinessCategory.new
hc_social.name = "Social"
hc_social.save
hc_social.happiness_questions << HappinessQuestion.find(5)
hc_social.happiness_questions << HappinessQuestion.find(7)
hc_social.happiness_questions << HappinessQuestion.find(20)
hc_social.happiness_questions << HappinessQuestion.find(30)

hc_oxford = HappinessCategory.new
hc_oxford.name = "Oxford Happiness Questionnaire"
hc_oxford.save
(4..32).each do |q|
	hc_oxford.happiness_questions << HappinessQuestion.find(q)
end

hc_esteem = HappinessCategory.new
hc_esteem.name = "Self Esteem"
hc_esteem.save
hc_esteem.happiness_questions << HappinessQuestion.find(4)
hc_esteem.happiness_questions << HappinessQuestion.find(16)
hc_esteem.happiness_questions << HappinessQuestion.find(20)
hc_esteem.happiness_questions << HappinessQuestion.find(29)

hc_health = HappinessCategory.new
hc_health.name = "Health and Energy"
hc_health.save
hc_health.happiness_questions << HappinessQuestion.find(8)
hc_health.happiness_questions << HappinessQuestion.find(24)
hc_health.happiness_questions << HappinessQuestion.find(28)
hc_health.happiness_questions << HappinessQuestion.find(31)

hc_opt = HappinessCategory.new
hc_opt.name = "Optimism"
hc_opt.save
hc_opt.happiness_questions << HappinessQuestion.find(6)
hc_opt.happiness_questions << HappinessQuestion.find(9)
hc_opt.happiness_questions << HappinessQuestion.find(12)
hc_opt.happiness_questions << HappinessQuestion.find(13)
hc_opt.happiness_questions << HappinessQuestion.find(19)
hc_opt.happiness_questions << HappinessQuestion.find(27)
hc_opt.happiness_questions << HappinessQuestion.find(32)

hc_humor = HappinessCategory.new
hc_humor.name = "Humor"
hc_humor.save
hc_humor.happiness_questions << HappinessQuestion.find(10)
hc_humor.happiness_questions << HappinessQuestion.find(14)

(1..20).each { |num|
	hr = HappinessResponse.new
	hr.user = User.find(1)
	hr.happiness_question = HappinessQuestion.find(num)
	hr.value = 1 + rand(6)
	puts hr.user.username + " answered Q" + num.to_s + " with " + hr.value.to_s
	hr.save
}

# need readables, upvotes, downvotes

comment_data = [
	{'activity_type_id' => 1, 'content' => 'Should I buy myself good running shoes?', 'signature' => 'curious', 'author_id' => 4},
	{'activity_type_id' => 1, 'content' => 'I love running!!! <3', 'signature' => 'excited', 'author_id' => 2},
	{'activity_type_id' => 1, 'content' => 'Is running bad for someone with flat feet?', 'signature' => 'Xandra', 'author_id' => 1},
	{'activity_type_id' => 2, 'content' => 'Reading is stupid', 'signature' => 'coolkid92', 'author_id' => 7},
	{'activity_type_id' => 2, 'content' => 'I never realized how fulfilling reading could be until my friend showed me the wonderful novel Twilight! Respond if you want to talk about this amazing series!!!', 'signature' => 'happy', 'author_id' => 3},
	{'activity_type_id' => 2, 'content' => 'Reading is super stupid', 'signature' => 'stillcool', 'author_id' => 7},
	{'activity_type_id' => 2, 'content' => 'What\'s your favorite book?', 'signature' => 'Xandra', 'author_id' => 1},
]

response_data = [
	{'comment_id' => 1, 'content' => 'Nah, it\'s not really necessary', 'signature' => 'Alec', 'author_id' => 2},
	{'comment_id' => 1, 'content' => 'Good tennis shoes are a must!', 'signature' => 'happy', 'author_id' => 3},
	{'comment_id' => 3, 'content' => 'I dunno go ask a doctor', 'signature' => 'duh', 'author_id' => 7},
	{'comment_id' => 7, 'content' => 'Game of Thrones!', 'signature' => 'happy', 'author_id' => 4},
	{'comment_id' => 7, 'content' => 'Wait, no, Storm of Swords!', 'signature' => 'happy', 'author_id' => 4},
	{'comment_id' => 7, 'content' => 'Kiterunner!', 'signature' => 'happy', 'author_id' => 5},
	{'comment_id' => 7, 'content' => 'Prey by Michael Chrichton', 'signature' => 'may he RIP', 'author_id' => 6},
]

for datum in comment_data do
	comment = Comment.create(content: datum['content'], signature: datum['signature'], activity_type_id: datum['activity_type_id'], author_id: datum['author_id'])
    comment.readers << User.all
end

for datum in response_data do
	response = Response.create(content: datum['content'], signature: datum['signature'], comment_id: datum['comment_id'], author_id: datum['author_id'])
    response.readers << User.all
end
