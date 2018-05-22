$title Project

set beer/Jungle, Hopalicious, Heron, MirrorPond, Sofie,
Guinness, K4, Potosi, Schlitz, Smithwicks, SCow, Bern,
Stella, Cider, Vintage/

positive variables X(beer), numSold(beer), expectedSales(beer), initialMargin, individualMargin(beer);

scalar margin;
margin = .223;

free variable netProfit;

table data(beer,*)
            price   costOZ  pourOZ   quantity
Jungle      5.50    .07     16       192
Hopalicious 5.50    .065    16       147
Heron       7       .12     12       121
MirrorPond  6       .088    16       135
Sofie       7.50    .15     13       90
Guinness    6.75    .09     20       876
K4          6       .073    12       432
Potosi      5.50    .065    16       102
Schlitz     3.50    .039    14       153
Smithwicks  6.75    .088    16       369
SCow        5       .065    16       567
Bern        9       .273    9        59
Stella      6       .086    13.5     175
Cider       6.50    .093    16       146
Vintage     5.50    .08     12       82;

X.lo(beer) = data(beer,'price') - .35;
X.l(beer) = data(beer,'price');
X.up(beer) = data(beer,'price') + .35;

numSold.l(beer) = data(beer,'quantity')*((data(beer,'price')/X.l(beer))**2);

parameter cost(beer), elasticity(beer);
cost(beer) = data(beer,'costOZ')*data(beer,'pourOZ');

individualMargin.l(beer) = (data(beer,'costOZ')*data(beer,'pourOZ'))/(data(beer,'price'));
initialMargin.l = (sum(beer,cost(beer)*data(beer,'quantity')))/(sum(beer,data(beer,'price')*data(beer,'quantity')));

equations averageProfitMargin,
priceElasticity1(beer),
objective1;

averageProfitMargin..
sum(beer,cost(beer)*numSold.l(beer)) =e= sum(beer,X(beer)*data(beer,'quantity'))*margin;

priceElasticity1(beer)..
numSold.l(beer) =e= data(beer,'quantity')*(data(beer,'price')/X.l(beer));

objective1..
netProfit =e= sum(beer,X(beer)*numSold.l(beer) - cost(beer)*numSold.l(beer));

model project /all/;
solve project using nlp max netProfit;

expectedSales.l(beer) = data(beer,'quantity')*((data(beer,'price')/X.l(beer))**2);

display X.l;
display expectedSales.l;
display netProfit.l;