bb <- "@article{miller1995wordnet,
  title={WordNet: a lexical database for English},
author={Miller, George A},
journal={Communications of the ACM},
volume={38},
number={11},
pages={39--41},
year={1995},
publisher={ACM},
notes={some notes},
random_field_y={xx},
}"

bb <- "@article{rackes2014using,
  title={Using multiobjective optimizations to discover dynamic building ventilation strategies that can improve indoor air quality and reduce energy use},
  author={Rackes, Adams and Waring, Michael S},
  journal={Energy and Buildings},
  volume={75},
  pages={272--280},
  year={2014},
  publisher={Elsevier}
}"

write(bb, 'tmp.dat')


yy <- ReadBib('tmp.dat')
