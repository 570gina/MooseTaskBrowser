Class {
	#name : #MooseTaskRuntimeTest,
	#superclass : #TestCase,
	#instVars : [
		'customTask',
		'task1',
		'task2',
		'task3',
		'task4',
		'task1dash1'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #running }
MooseTaskRuntimeTest >> setUp [
	customTask := MooseCustomTask new
		with: [ :v |  ]
		description: 'desc1'
		length: 0.
	task1 := customTask asTaskRuntime.
	task1dash1 := customTask asTaskRuntime.
	task2 := (MooseCustomTask new
		with: [ :v |  ]
		description: 'desc2'
		length: 0) asTaskRuntime.
	task3 := (MooseCustomTask new
		with: [ :v |  ]
		description: 'desc3'
		length: 0) asTaskRuntime.
	task4 := (MooseCustomTask new
		with: [ :v |  ]
		description: 'desc4'
		length: 0) asTaskRuntime
]

{ #category : #running }
MooseTaskRuntimeTest >> testCombiningComposedTaskAndSingleTaskProducesANewComposedTaskWithThreeTasks [
	| combination combination2 |
	combination := task1 combineWith: task2.
	combination2 := combination combineWith: task3.
	self assert: (combination isKindOf: MooseTaskComposedRuntime).
	self assert: (combination2 isKindOf: MooseTaskComposedRuntime).
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
MooseTaskRuntimeTest >> testCombiningSingleTaskAndComposedTaskProducesANewComposedTaskWithThreeTasks [
	| combination combination2 |
	combination := task2 combineWith: task3.
	combination2 := task1 combineWith: combination.
	self assert: (combination isKindOf: MooseTaskComposedRuntime).
	self assert: (combination2 isKindOf: MooseTaskComposedRuntime).
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
MooseTaskRuntimeTest >> testCombiningTwoComposedTasksProducesANewComposedTaskWithFourTasks [
	| combination sub1 sub2 |
	sub1 := task1 combineWith: task2.
	sub2 := task3 combineWith: task4.
	combination := sub1 combineWith: sub2.
	self assert: (combination isKindOf: MooseTaskComposedRuntime).
	self assert: (sub1 isKindOf: MooseTaskComposedRuntime).
	self assert: (sub2 isKindOf: MooseTaskComposedRuntime).
	self deny: sub1 equals: combination.
	self deny: sub2 equals: combination.
	self assert: combination tasks size equals: 4.
	self assert: combination tasks equals: sub1 tasks , sub2 tasks
]

{ #category : #running }
MooseTaskRuntimeTest >> testCombiningTwoSingleTasksProducesANewComposedTask [
	| combination |
	combination := task1 combineWith: task2.
	self assert: (combination isKindOf: MooseTaskComposedRuntime)
]

{ #category : #running }
MooseTaskRuntimeTest >> testTaskRuntimeGivesAllwaysANewRuntime [
	self deny: task1 equals: task1dash1.
	self assert: task1 task equals: task1dash1 task
]
