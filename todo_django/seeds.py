from task.models import Task

for _ in range(10):
    Task(title="test", description="test").save()
