Class {
	#name : #MooseComposedTaskTest,
	#superclass : #TestCase,
	#instVars : [
		'customTask',
		'task1',
		'task2',
		'task3',
		'task4'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #running }
MooseComposedTaskTest >> setUp [
	customTask := MooseCustomTask new
		with: [   ]
		description: 'desc1'
		length: 0.
	task1 := customTask.
	task2 := MooseCustomTask new
		with: [   ]
		description: 'desc2'
		length: 0.
	task3 := MooseCustomTask new
		with: [ ]
		description: 'desc3'
		length: 0.
	task4 := MooseCustomTask new
		with: [ ]
		description: 'desc4'
		length: 0
]

{ #category : #running }
MooseComposedTaskTest >> testCombiningComposedTaskAndSingleTaskProducesANewComposedTaskWithThreeTasks [
	| combination combination2 |
	combination := task1 combineWith: task2.
	combination2 := combination combineWith: task3.
	self assert: (combination isKindOf: MooseComposedTask).
	self assert: (combination2 isKindOf: MooseComposedTask).
	self deny: combination equals: combination2.
	self assert: combination2 tasks size equals: 3.
	self
		assert: combination2 tasks asArray
		equals:
			{task1.
			task2.
			task3}
]

{ #category : #running }
MooseComposedTaskTest >> testCombiningSingleTaskAndComposedTaskProducesANewComposedTaskWithThreeTasks [
	| combination combination2 |
	combination := task2 combineWith: task3.
	combination2 := task1 combineWith: combination.
	self assert: (combination isKindOf: MooseComposedTask).
	self assert: (combination2 isKindOf: MooseComposedTask).
	self deny: combination equals: combination2.
	self assert: combination2 tasks size equals: 3.
	self
		assert: combination2 tasks asArray
		equals:
			{task1.
			task2.
			task3}
]

{ #category : #running }
MooseComposedTaskTest >> testCombiningTwoComposedTasksProducesANewComposedTaskWithFourTasks [
	| combination sub1 sub2 |
	sub1 := task1 combineWith: task2.
	sub2 := task3 combineWith: task4.
	combination := sub1 combineWith: sub2.
	self assert: (combination isKindOf: MooseComposedTask).
	self assert: (sub1 isKindOf: MooseComposedTask).
	self assert: (sub2 isKindOf: MooseComposedTask).
	self deny: sub1 equals: combination.
	self deny: sub2 equals: combination.
	self assert: combination tasks size equals: 4.
	self assert: combination tasks equals: sub1 tasks , sub2 tasks
]

{ #category : #running }
MooseComposedTaskTest >> testCombiningTwoSingleTasksProducesANewComposedTask [
	| combination |
	combination := task1 combineWith: task2.
	self assert: (combination isKindOf: MooseComposedTask)
]
