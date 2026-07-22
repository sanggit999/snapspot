from rest_framework.renderers import JSONRenderer  # type: ignore

class StandardJSONRenderer(JSONRenderer):
    """
    Custom JSON Renderer bọc mọi response thành công theo chuẩn Response Envelope của SnapSpot:
    {
        "success": true,
        "data": { ... }
    }
    """
    def render(self, data, accepted_media_type=None, renderer_context=None):
        response = renderer_context.get('response') if renderer_context else None
        status_code = response.status_code if response else 200

        # Nếu response đã dạng error envelope từ custom exception handler thì không bọc lại
        if isinstance(data, dict) and 'success' in data and data['success'] is False:
            return super().render(data, accepted_media_type, renderer_context)

        # Trạng thái 204 No Content
        if status_code == 204 or data is None:
            formatted_data = {
                "success": True,
                "data": None
            }
        elif status_code >= 400:
            # Phòng ngừa trường hợp lỗi chưa được bọc
            formatted_data = {
                "success": False,
                "error": {
                    "code": "HTTP_ERROR",
                    "message": "Đã xảy ra lỗi khi xử lý yêu cầu.",
                    "details": data
                }
            }
        else:
            # Tách riêng meta pagination nếu có
            meta = None
            if isinstance(data, dict) and 'meta' in data and 'results' in data:
                meta = data.pop('meta')
                results = data.pop('results')
                formatted_data = {
                    "success": True,
                    "data": results,
                    "meta": meta
                }
            else:
                formatted_data = {
                    "success": True,
                    "data": data
                }

        return super().render(formatted_data, accepted_media_type, renderer_context)
