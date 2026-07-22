from rest_framework.views import exception_handler  # type: ignore
from rest_framework.exceptions import APIException, Throttled  # type: ignore
from rest_framework.response import Response  # type: ignore
from rest_framework import status  # type: ignore

def custom_exception_handler(exc, context):
    """
    Custom Exception Handler bọc mọi lỗi HTTP (400, 401, 403, 404, 429, 500)
    theo chuẩn API Envelope của SnapSpot:
    {
        "success": false,
        "error": {
            "code": "ERROR_CODE",
            "message": "Thông báo lỗi",
            "details": { ... }
        }
    }
    """
    response = exception_handler(exc, context)

    if response is not None:
        error_code = getattr(exc, 'default_code', 'ERROR').upper()
        message = "Đã xảy ra lỗi khi xử lý yêu cầu."
        
        if hasattr(exc, 'detail'):
            if isinstance(exc.detail, str):
                message = exc.detail
            elif isinstance(exc.detail, dict):
                if 'detail' in exc.detail:
                    message = str(exc.detail['detail'])
                else:
                    message = "Dữ liệu đầu vào không hợp lệ."
            elif isinstance(exc.detail, list):
                message = str(exc.detail[0])

        # Xử lý riêng cho Rate Limit (HTTP 429)
        if isinstance(exc, Throttled):
            error_code = "TOO_MANY_REQUESTS"
            wait_seconds = exc.wait
            message = f"Bạn đã vượt quá giới hạn lượt gọi API. Vui lòng thử lại sau {int(wait_seconds or 60)} giây."

        response.data = {
            "success": False,
            "error": {
                "code": error_code,
                "message": message,
                "details": response.data if isinstance(response.data, dict) else {"non_field_errors": response.data}
            }
        }
    else:
        # Unhandled 500 exceptions
        response = Response(
            {
                "success": False,
                "error": {
                    "code": "INTERNAL_SERVER_ERROR",
                    "message": "Lỗi máy chủ nội bộ. Vui lòng thử lại sau.",
                    "details": None
                }
            },
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

    return response
