retrieving
retrieveQuestions: aUser
	| qRet temp followingCol topicsCol newsCol popularTCol averageVotes |
	qRet := OrderedCollection new.
	option = #social
		ifTrue: [ followingCol := OrderedCollection new.
			aUser following
				do: [ :follow | followingCol addAll: follow questions ].
			temp := followingCol
				asSortedCollection: [ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size) ].
	option = #topics
		ifTrue: [ topicsCol := OrderedCollection new.
			aUser topics do: [ :topic | topicsCol addAll: topic questions ].
			temp := topicsCol
				asSortedCollection: [ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size) ].
	option = #news
		ifTrue: [ newsCol := OrderedCollection new.
			cuoora questions
				do: [ :q | 
					q timestamp asDate = Date today
						ifTrue: [ newsCol add: q ] ].
			temp := newsCol
				asSortedCollection: [ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size) ].
	option = #popularToday
		ifTrue: [ popularTCol := OrderedCollection new.
			cuoora questions
				do: [ :q | 
					q timestamp asDate = Date today
						ifTrue: [ popularTCol add: q ] ].
			averageVotes := (cuoora questions
				sum: [ :q | q positiveVotes size ]) / popularTCol size.
			temp := (popularTCol
				select: [ :q | q positiveVotes size >= averageVotes ])
				asSortedCollection: [ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size) ].
	^ qRet reject: [ :q | q user = aUser ]