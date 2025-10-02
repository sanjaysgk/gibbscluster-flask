#!/usr/bin/env python3
from app.celery_app import celery
from app import create_app

app = create_app()
app.app_context().push()