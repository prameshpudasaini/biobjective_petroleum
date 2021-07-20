$inlineCom [ ]
$eolCom //

$stitle Example Model Definitions
Set
         i 'sources' / Siliguri, Barauni, Raxaul, Baitalpur, Mughalsarai, Gonda, Banthara /
         j 'destinations' / Charali, Biratnagar, Janakpur, Birgunj, Amlekhgunj, Kathmandu, Pokhara, Bhairahawa, Nepalgunj, Dhangadhi /
         p 'products' / Diesel, Petrol /
         k 'objective functions' / cost, loss /;
*Deterministic Time period = T3

$set min -1
$set max +1

Parameter
         dir(k) 'direction of the objective functions 1 for max and -1 for min' / cost -1, loss -1 /

Table fij(i,j)
                Charali        Biratnagar        Janakpur        Birgunj        Amlekhgunj        Kathmandu        Pokhara        Bhairahawa        Nepalgunj        Dhangadhi
Siliguri              1                 1               1            100                 1                1              1               100              100              100
Barauni               1                 1               1              1                 1                1              1                 1              100              100
Raxaul                1                 1               1              1                 1                1              1                 1                1              100
Baitalpur           100                 1               1              1                 1                1              1                 1                1                1
Mughalsarai         100               100             100            100                 1                1              1                 1                1                1
Gonda               100               100             100            100               100              100              1                 1                1                1
Banthara            100               100             100            100               100              100            100                 1                1                1;

Table wdist(i,j)
                Charali        Biratnagar        Janakpur        Birgunj        Amlekhgunj        Kathmandu        Pokhara        Bhairahawa        Nepalgunj        Dhangadhi
Siliguri             46               146             301            423               410              708            675               628              870             1024
Barauni             340               287             208            254               283              581            548               504              743              897
Raxaul              384               322             146              7                36              334            301               257              497              651
Baitalpur           567               457             330            191               220              479            446               153              343              476
Mughalsarai         727               653             489            349               421              650            617               324              408              541
Gonda               762               688             524            384               415              536            503               210              130              263
Banthara            990               916             752            612               643              760            727               434              238              151;

Table wloss(p,i,j)
                      Charali  Biratnagar    Janakpur     Birgunj  Amlekhgunj   Kathmandu     Pokhara  Bhairahawa   Nepalgunj   Dhangadhi
Diesel. Siliguri            0           0          80           0           0        2930        2330           0           0           0
Diesel. Barauni          3680        2330        3300        2100        3000        6530        6000        3450        3000        2930
Diesel. Raxaul           1580         300        1800           0         300        4880        4050        1350         900         830
Diesel. Baitalpur         520           0         600           0           0        3450        2850         450           0           0
Diesel. Mughalsarai       750           0         830           0           0        3680        3080         380          80           0
Diesel. Gonda            1130           0        1200           0         300        4050        3450         900         450         380
Diesel. Banthara         2780        1500        2850        1200        1950        5700        5100        2550        2100        2030
Petrol. Siliguri            0         110        1060           0           0        4880        4980         210           0        1590
Petrol. Barauni          2860        2540        3500        2230        2650        7420        7740        3070        2120        4450
Petrol. Raxaul            850         640        2440           0         320        6360        6150        1060         110        2440
Petrol. Baitalpur         420         210        1480           0         320        5300        5410         640           0        2010
Petrol. Mughalsarai      1270        1060        2330         640        1170        6150        6250        1480         530        2860
Petrol. Gonda            1910        1700        2970        1270        1800        6780        6890        2120        1170        3500
Petrol. Banthara         2440        2230        3500        1800        2330        7310        7420        2650        1700        4030;

Table supply(p,i)
           Siliguri           Barauni          Raxaul      Baitalpur       Mughalsarai            Gonda       Banthara
Diesel        12100            125700           56100          21200              7900            32000          15500
Petrol         5600             48000           17900           6500              7800             7400           3400;

Table demand(p,j)
            Charali        Biratnagar        Janakpur        Birgunj        Amlekhgunj        Kathmandu        Pokhara        Bhairahawa        Nepalgunj        Dhangadhi
Diesel         8600             23400            7400          10600             42600            25000           7000             24300            18500             8600
Petrol         2800              7000            2800           2200              8300            17300           2700              5600             3800             1700;

Parameter
         objvf1          'value of objective function 1 in kl-km'
         objvf2          'value of objective function 2 in l'

Variable
         z(k) 'objective function variables';

Positive variable
         quantity(p,i,j)         'amount of product p to be shipped from i to j in a time period';

Equation
         objcost                 'objective for minimizing cost in kl-km'
         objloss                 'objective for minimizing loss in l'
         defsup(p,i)             'supply constraint'
         defdem(p,j)             'demand constraint'
         defnnc(p,i,j)           'non-negativity constraint';

         objcost..               sum((p,i,j), wdist(i,j)*fij(i,j)*quantity(p,i,j)) =e= z('cost');
         objloss..               sum((p,i,j), wloss(p,i,j)*fij(i,j)*quantity(p,i,j)/1000) =e= z('loss');
         defsup(p,i)..           sum(j, quantity(p,i,j)) =l= supply(p,i);
         defdem(p,j)..           sum(i, quantity(p,i,j)) =g= demand(p,j);
         defnnc(p,i,j)..         quantity(p,i,j) =g= 0;

Model example / all /;

$sTitle eps-constraint Method
Set
   k1(k)  'the first element of k'
   km1(k) 'all but the first elements of k'
   kk(k)  'active objective function in constraint allobj';

k1(k)$(ord(k) = 1) = yes;
km1(k)  = yes;
km1(k1) =  no;

Parameter
   rhs(k)    'right hand side of the constrained obj functions in eps-constraint'
   maxobj(k) 'maximum value from the payoff table'
   minobj(k) 'minimum value from the payoff table'
   numk(k)   'ordinal value of k starting with 1';

Scalar
   iter         'total number of iterations'
   infeas       'total number of infeasibilities'
   elapsed_time 'elapsed time for payoff and e-sonstraint'
   start        'start time'
   finish       'finish time';

Variable
   a_objval 'auxiliary variable for the objective function'
   obj      'auxiliary variable during the construction of the payoff table'
   sl(k)    'slack or surplus variables for the eps-constraints';

Positive Variable sl;

Equation
   con_obj(k) 'constrained objective functions'
   augm_obj   'augmented objective function to avoid weakly efficient solutions'
   allobj     'all the objective functions in one expression';

con_obj(km1).. z(km1) - dir(km1)*sl(km1) =e= rhs(km1);

* We optimize the first objective function and put the others as constraints
* the second term is for avoiding weakly efficient points

augm_obj..
   a_objval =e= sum(k1,dir(k1)*z(k1))
         + 1e-3*sum(km1,power(10,-(numk(km1) - 1))*sl(km1)/(maxobj(km1) - minobj(km1)));

allobj.. sum(kk, dir(kk)*z(kk)) =e= obj;

Model
   mod_payoff    / example, allobj            /
   mod_epsmethod / example, con_obj, augm_obj /;

Parameter payoff(k,k) 'payoff tables entries';

Alias (k,kp);

option optCr = 0, limRow = 0, limCol = 0, solPrint = off, solveLink = %solveLink.LoadLibrary%;

* Generate payoff table applying lexicographic optimization
loop(kp,
   kk(kp) = yes;
   repeat
      solve mod_payoff using mip maximizing obj;
      payoff(kp,kk) = z.l(kk);
      z.fx(kk) = z.l(kk); // freeze the value of the last objective optimized
      kk(k++1) = kk(k);   // cycle through the objective functions
   until kk(kp);
   kk(kp) = no;
*  release the fixed values of the objective functions for the new iteration
   z.up(k) =  inf;
   z.lo(k) = -inf;
);
if(mod_payoff.modelStat <> %modelStat.optimal% and
   mod_payoff.modelStat <> %modelStat.integer Solution%,
   abort 'no optimal solution for mod_payoff';);

File fx / D_MOA_T3_Q.txt /;
put  fx ' PAYOFF TABLE'/;
loop(kp,
   loop(k, put payoff(kp,k):12:2;);
   put /;
);

minobj(k) = smin(kp,payoff(kp,k));
maxobj(k) = smax(kp,payoff(kp,k));

* gridpoints are calculated as the range (difference between max and min) of
* the 2nd objective function from the payoff table
$if not set gridpoints $set gridpoints 19
Set
   g         'grid points' / g0*g%gridpoints% /
   grid(k,g) 'grid';

Parameter
   gridrhs(k,g) 'RHS of eps-constraint at grid point'
   maxg(k)      'maximum point in grid for objective'
   posg(k)      'grid position of objective'
   firstOffMax  'some counters'
   lastZero     'some counters'
*  numk(k) 'ordinal value of k starting with 1'
   numg(g)      'ordinal value of g starting with 0'
   step(k)      'step of grid points in objective functions'
   jump(k)      'jumps in the grid points traversing';

lastZero = 1;
loop(km1,
   numk(km1) = lastZero;
   lastZero  = lastZero + 1;
);
numg(g) = ord(g) - 1;

grid(km1,g) = yes; // Here we could define different grid intervals for different objectives
maxg(km1)   = smax(grid(km1,g), numg(g));
step(km1)   = (maxobj(km1) - minobj(km1))/maxg(km1);
*step(k) = 1;
gridrhs(grid(km1,g))$(dir(km1) = -1) = maxobj(km1) - numg(g)/maxg(km1)*(maxobj(km1) - minobj(km1));
gridrhs(grid(km1,g))$(dir(km1) =  1) = minobj(km1) + numg(g)/maxg(km1)*(maxobj(km1) - minobj(km1));

put / ' Grid points' /;
loop(g,
   loop(km1, put gridrhs(km1,g):12:2;);
   put /;
);
put / 'Efficient solutions' /;

* Walk the grid points and take shortcuts if the model becomes infeasible or
* if the calculated slack variables are greater than the step size
posg(km1) = 0;
iter   = 0;
infeas = 0;
start  = jnow;

repeat
   rhs(km1) = sum(grid(km1,g)$(numg(g) = posg(km1)), gridrhs(km1,g));
   solve mod_epsmethod maximizing a_objval using mip;
   iter = iter + 1;
   if(mod_epsmethod.modelStat<>%modelStat.optimal% and
      mod_epsmethod.modelStat<>%modelStat.integer Solution%,
      infeas = infeas + 1; // not optimal is in this case infeasible
      put iter:5:0, '  infeasible' /;
      lastZero = 0;
      loop(km1$(posg(km1)  > 0 and lastZero = 0), lastZero = numk(km1));
      posg(km1)$(numk(km1) <= lastZero) = maxg(km1); // skip all solves for more demanding values of rhs(km1)
   else
      put iter:5:0;
      loop(k, put z.l(k):12:2;);
      jump(km1) = 1;
*     find the first off max (obj function that hasn't reach the final grid point).
*     If this obj.fun is k then assign jump for the 1..k-th objective functions
*     The jump is calculated for the innermost objective function (km=1)
      jump(km1)$(numk(km1) = 1) = 1 + floor(sl.L(km1)/step(km1));
      loop(km1$(jump(km1)  > 1), put '   jump';);
      put /;
      put ' ':5 'quantity' /
      loop((p,i,j)$(abs(quantity.l(p,i,j))>1e-6), put ' ':7 p.tl i.tl j.tl quantity.l(p,i,j) /);
   );
*  Proceed forward in the grid
   firstOffMax = 0;
   loop(km1$(posg(km1) < maxg(km1) and firstOffMax = 0),
      posg(km1)   = min((posg(km1) + jump(km1)),maxg(km1));
      firstOffMax = numk(km1);
   );
   posg(km1)$(numk(km1) < firstOffMax) = 0;
   abort$(iter > 1000) 'more than 1000 iterations, something seems to go wrong';
until sum(km1$(posg(km1) = maxg(km1)),1) = card(km1) and firstOffMax = 0;

finish = jnow;
elapsed_time = (finish - start)*60*60*24;

put /;
put 'Infeasibilities = ', infeas:5:0 /;
put 'Elapsed time: ',elapsed_time:10:2, ' seconds' /;
