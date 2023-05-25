% is_dibr_do_refinement = false;

pics_dir = 'COLMAP-Ballet/';
if is_dibr_do_refinement == false
    depthColorRefinement(pics_dir); % ��ɫͼ�����ͼ�˲� Color Depth Refinement
end

refined_dir_name = 'DepthColorRefinement/';
color_dir_name = 'Color/';
depth_dir_name = 'Depth/';
prc_dir_name = [pics_dir,refined_dir_name,color_dir_name];
prd_dir_name = [pics_dir,refined_dir_name,depth_dir_name];
pc_dir_name = [pics_dir, color_dir_name];
pd_dir_name = [pics_dir, depth_dir_name];

Zfar = 0.0;
Znear = 0.0;
Znears = {12.586273288726806, 13.728549690246583, 14.945539360046388, 14.661488456726074, 14.859316558837891, 15.3220947265625, 14.390948600769043, 13.413757095336914};
Zfars = {16.64102554321289, 17.55347785949707, 18.677749252319337, 18.306122665405272, 18.38795722961426, 18.73519515991211, 17.69033317565918, 16.610079727172852};

K_0 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];
K_1 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];
K_2 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];
K_3 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];
K_4 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];
K_5 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];
K_6 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];
K_7 = [
    3044.0635419606206	2.489820	512
    0.0	3009.6048182665845	384
    0.0	0.0	1.0
    ];


Rt_0 = getCOLMAPRt([0.98749697135389836 -0.003786502474141017 0.15724236592611546 0.010499158244780876 -6.751550346234132 -0.17824479831989892 0.41317896154388739]);
Rt_1 = getCOLMAPRt([0.99472934302838856 -0.0010177826403632115 0.10218432773644226 -0.0084179214690414342 -5.1735468671299385 0.098597856112081203 0.80113389297247595]);
Rt_2 = getCOLMAPRt([0.99901762906659275 0.001690101428109704 0.042442175420306399 -0.012632581561916571 -3.4411289887515557 0.11975796605983054 1.3893117177886436]);
Rt_3 = getCOLMAPRt([0.99978115675590096 -0.0010808138169555014 -0.02073995586960346 -0.0025148892326837089 -1.6275598205313264 0.0066251851363137021 0.64883530453320837]);
Rt_4 = getCOLMAPRt([0.99650746508833676 -0.0021204817327803646 -0.081878106204424747 -0.016258883873600534 0.20157780677292286 0.014328653774067139 0.63970522746431935]);
Rt_5 = getCOLMAPRt([0.99005192190333569 -0.0019310925622287984 -0.14067259335410762 -0.0021643234641356814 1.9729798701647112 -0.018250136228688166 1.1386067253734131]);
Rt_6 = getCOLMAPRt([0.98086274236649984 -0.00046972165447407946 -0.19469243122932481 0.0017079873686360453 3.5996833401654666 -0.0061893858420230532 0.43008263639039784]);
Rt_7 = getCOLMAPRt([0.96964444487057244 -0.0023138163739561198 -0.24450556815860061 -0.0011506193406417876 5.0382075222994214 -0.075371366994348307 -0.13638712401597045]);

%Ks = {inv(K_0), inv(K_1), inv(K_2), inv(K_3), inv(K_4), inv(K_5), inv(K_6), inv(K_7)};
Ks = {K_0, K_1, K_2, K_3, K_4, K_5, K_6, K_7};
Rts = {Rt_0, Rt_1, Rt_2, Rt_3, Rt_4, Rt_5, Rt_6, Rt_7};

%Ks = {K_7, K_6, K_5, K_4, K_3, K_2, K_1, K_0};
%Rts = {Rt_7, Rt_6, Rt_5, Rt_4, Rt_3, Rt_2, Rt_1, Rt_0};


%LoadBalletData;