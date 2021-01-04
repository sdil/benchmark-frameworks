from django.shortcuts import render
from .models import Task
from .serializers import TaskSerializer
from rest_framework.generics import ListAPIView


# Create your views here.


class TodoRetrieveAPIView(ListAPIView):
    serializer_class = TaskSerializer

    def get_queryset(self):
        return Task.objects.all()

