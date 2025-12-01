import json
from datetime import datetime

def lambda_handler(event, context):
    """
    Lambda function triggered by ECR image push events.
    Logs image push details to CloudWatch Logs.
    """
    
    try:
        print("=" * 60)
        print("ECR IMAGE PUSH EVENT DETECTED")
        print("=" * 60)
        
        # Parse ECR event from EventBridge
        detail = event.get('detail', {})
        
        repository_name = detail.get('repository-name', 'Unknown')
        image_tag = detail.get('image-tag', 'Unknown')
        result = detail.get('result', 'Unknown')
        
        # Log formatted information
        print(f"\n Repository: {repository_name}")
        print(f"  Image Tag: {image_tag}")
        print(f"  Result: {result}")
        print(f"\n Full Event: {json.dumps(event, indent=2)}")
        print("=" * 60)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'ECR push event logged successfully',
                'repository': repository_name,
                'tag': image_tag
            })
        }
        
    except Exception as e:
        print(f"Error processing event: {str(e)}")
        print(f"Event: {json.dumps(event, indent=2)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }