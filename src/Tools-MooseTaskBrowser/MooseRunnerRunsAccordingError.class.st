"
I'm a runner.
When an error occurs, I will
-stop running
-and open the debugger (Choose the next action)

(Important!)
If the error is a custom MooseTaskError will be ignored.


"
Class {
	#name : #MooseRunnerRunsAccordingError,
	#superclass : #MooseAbstractRunner,
	#category : #'Tools-MooseTaskBrowser-Core'
}

{ #category : #accessing }
MooseRunnerRunsAccordingError >> order [ 
^2
]

{ #category : #running }
MooseRunnerRunsAccordingError >> printOn: aStream [
	aStream nextPutAll: 'Run According Error'
]

{ #category : #running }
MooseRunnerRunsAccordingError >> runTask: step input: result [
	 [ step run: result ]
		on: MooseTaskError
		do: [ ^ step ] 
]
