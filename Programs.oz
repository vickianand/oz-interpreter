

declare Prog0 = [[nop] [nop] [nop]]

declare Prog1 = [  [localvar ident(x) [localvar ident(y) [localvar ident(x) [nop]]]]    [localvar ident(a) [localvar ident(b) [localvar ident(c) [nop]]]]   ]

declare Prog2 = [localvar ident(x) [localvar ident(y) [localvar ident(x) [nop]]]]

declare Prog3 = [localvar ident(x) 
		 [localvar ident(y) 
		  [bind ident(x) ident(y)] 
		  [localvar ident(x) 
		   [nop]
		  ]
		 ]
		]

declare Prog4 = [localvar ident(x) 
		 [localvar ident(y) 
		  [bind ident(x) ident(y)] 
		  [localvar ident(x) 
		   [
		    [nop]
		    [bind ident(x) ident(y)]
		   ]
		  ]
		 ]
		]

declare Prog5 = [localvar ident(x) 
		 [localvar ident(y) 
		  [localvar ident(z) 
		   [nop]
		   [bind ident(x) ident(y)]
		   [nop]
		   [bind ident(z) ident(y)]
		   [nop]
		  ]
		 ]
		]

declare Prog6 = [localvar ident(x) 
		 [localvar ident(y) 
		  [localvar ident(z) 
		   [nop]
		   [bind ident(x) ident(y)]
		   [nop]
		   [bind ident(z) ident(y)]
		   [nop]
		   [bind literal(100) ident(x)]
		  ]
		 ]
		]


declare	R1 = 	[record literal(a)
					[
						[literal(feature1) ident(x1)]
						[literal(feature2) ident(x2)]
						[literal(featuren) ident(xn)]
					]
				]


declare Prog7 = [localvar ident(x) 
		 [localvar ident(y) 
		  [localvar ident(z) 
		   [nop]
		   [bind ident(x) ident(y)]
		   [nop]
		   [bind ident(z) ident(y)]
		   [nop]
		   [bind [record literal(a)
					[
						[literal(feature1) literal(100)]
						[literal(feature2) literal(200)]
						[literal(featuren) literal(300)]
					]
				 ] 
				 ident(x)
			]
		  ]
		 ]
		]



declare Prog8 = [localvar ident(x) 
		 [localvar ident(y) 
		  [localvar ident(z) 
		   [nop]
		   [bind [record literal(a)
					[
						[literal(feature1) literal(123)]
						[literal(feature2) ident(z)]
						[literal(featuren) literal(100)]
					]
				 ] 
				 ident(x)
			]
			[bind [record literal(a)
					[
						[literal(feature1) literal(123)]
						[literal(feature2) literal(50)]
						[literal(featuren) literal(100)]
					]
				 ] 
				 ident(y)
			]
			[bind ident(x) ident(y)]
		  ]
		 ]
		]


declare Prog9 = [localvar ident(x) 
		 [localvar ident(y) 
		  [localvar ident(z) 
		   [nop]
		   [bind [record literal(a)
					[
						[literal(ghi) literal(123)]
						[literal(def) ident(z)]
						[literal(abc) literal(100)]
					]
				 ] 
				 ident(x)
			]
			[bind [record literal(a)
					[
						[literal(ghi) literal(123)]
						[literal(def) literal(50)]
						[literal(abc) literal(100)]
					]
				 ] 
				 ident(y)
			]
			[bind ident(z) literal(50)]
		  ]
		 ]
		]


declare Prog10 = [localvar ident(x) 
		 [localvar ident(y) 
		  [localvar ident(z) 
		   [nop]
		   [bind ident(x) bool(yes)]
		   [nop]
		   [bind ident(z) bool(no)]
		   [nop]
		   [ conditional ident(x) [bind ident(y) literal(100)] [bind ident(y) literal(31)] ]
		  ]
		 ]
		]

% below program checks for suspension
declare Prog10A = [localvar ident(x) 
		 [localvar ident(y) 
		  [localvar ident(z) 
		   [nop]
		   [bind ident(x) bool(yes)]
		   [nop]
		   [bind ident(z) bool(no)]
		   [nop]
		   [ conditional ident(y) [bind ident(y) literal(100)] [bind ident(y) literal(31)] ]
		  ]
		 ]
		]



declare Prog11 =  
[localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [localvar ident(result)
     [[bind ident(foo) literal(person)]
      [bind ident(bar) literal(age)]
      [bind ident(baz) [record literal(person) [[literal(age) literal(25)]]]]
      [nop]
      [match 
      	ident(baz) 
      	[record literal(person) [[literal(age) ident(quux)]]]
      	[bind ident(result) ident(quux)]
      	[bind ident(result) literal(f)]]
      [nop]
      [bind ident(result) literal(25)]
     ]
    ]
   ]
  ]
]



declare Prog12 =  
[localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [localvar ident(result)
     [[bind ident(foo) literal(person)]
      [bind ident(bar) literal(age)]
      [bind ident(baz) [record literal(person) [[literal(age) literal(25)]]]]
      [nop]
      [match
      	ident(baz)
      	[record ident(foo) [[ident(bar) ident(quux)]]]
       	[bind ident(result) ident(quux)]
       	[bind ident(result) literal(f)]]
      [nop]
      [bind ident(result) literal(25)]
     ]
    ]
   ]
  ]
]




declare Prog13 = 
[localvar ident(x) 
		 [localvar ident(y) 
		  [bind ident(x) [procedure [ident(x1) ident(x2)] [[nop] [nop]] ] ] 
		 ]
]



declare Prog14 = 
[localvar ident(x)
	[	 
		[bind ident(x) literal(3818)]
		[localvar ident(y) 
			[
				[bind ident(y) [procedure [ident(x1) ident(x2)] [[nop] [bind ident(x1) ident(x2)] [nop]] ] ] 
				[localvar ident(z) 
					[apply ident(y) ident(x) ident(z)]
				]
			]
		]
	]
]



declare Prog15 = 
[localvar ident(x)
	[localvar ident(y)
		[localvar ident(z)
			[bind ident(x) ident(y)]
			[bind ident(x) ident(z)]
			[bind ident(z) literal(103)]
			[bind ident(x) literal(103)] 
		]
	]
]


declare Prog16 = 
[localvar ident(x)
	[localvar ident(y)
		[localvar ident(z)
			[bind ident(x) [record literal(a) [[literal(f1) literal(31)][literal(f2) ident(x)]]]]
			[bind ident(y) [record literal(a) [[literal(f1) literal(31)][literal(f2) ident(y)]]]]			
			%[bind ident(x) ident(y)]
		]
	]
]
