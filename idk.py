from pydantic import BaseModel

class B(BaseModel):
    name: str

b = B(name="dkfjsdlkfj")
print(b.model_fields)
