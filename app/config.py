import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    
    # Celery configuration (updated for Celery 5.x+)
    broker_url = os.getenv('REDIS_URL', 'redis://localhost:6379/0')
    result_backend = os.getenv('REDIS_URL', 'redis://localhost:6379/0')
    broker_connection_retry_on_startup = True
    task_track_started = True
    task_serializer = 'json'
    result_serializer = 'json'
    accept_content = ['json']
    timezone = 'Australia/Melbourne'
    enable_utc = True
    
    # File upload configuration
    UPLOAD_FOLDER = os.getenv('UPLOAD_FOLDER', './data/uploads')
    RESULTS_FOLDER = os.getenv('RESULTS_FOLDER', './data/results')
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 16MB
    
    # GibbsCluster configuration
    GIBBSCLUSTER_PATH = os.getenv('GIBBSCLUSTER_PATH', '/path/to/gibbscluster')
    
    # Job configuration
    JOB_TIMEOUT = 600  # 10 minutes


class DevelopmentConfig(Config):
    DEBUG = True


class ProductionConfig(Config):
    DEBUG = False