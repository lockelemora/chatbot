from openai import OpenAI
from dotenv import load_dotenv
import os
import time
import json

#Load environment variables from .env file
load_dotenv

#Global variables
assistant_id_string = "asst_V8PYYXOba0CpeyYEKAzMXZPU"


#BODY
#Create a thread
def create_thread(client):
  thread = client.beta.threads.create()
  return thread


#Create a message and add it to the thread
def add_message(client, thread, user_input):
  message = client.beta.threads.messages.create(thread_id=thread.id,
                                                role='user',
                                                content=user_input)
  return message


#Create a run and print back the assistant respose
def create_run(client, thread, assistant):
  try:
    run = client.beta.threads.runs.create_and_poll(thread_id=thread.id,
                                                   assistant_id=assistant)

    #Loop through each tool in the required action section
    if run.status == "requires_action":
      #Define a list to store the tool outputs
      tool_outputs = []
      for tool in run.required_action.submit_tool_outputs.tool_calls:
        #Define the retun outputs for the functions
        output = tool.function.arguments
        function_name = tool.function.name
        
        #Append and create the tool_outputs list
        tool_outputs.append({
            "tool_call_id": tool.id,
            "output": output
        })
        print(f"Function recognized: {function_name} // {output}")

      #Submit all tool outputs at once
      if tool_outputs:
        try:
          run = client.beta.threads.runs.submit_tool_outputs_and_poll(
              thread_id=thread.id, run_id=run.id, tool_outputs=tool_outputs)
          print("Tool outputs submitted.")
        except Exception as e:
          print("Failed to submit", e)
      else:
        print("No tool outputs to submit")

    #Fetch and print assistant response
    messages = client.beta.threads.messages.list(thread_id=thread.id)
    assistant_response = messages.data[0].content[0].text.value
    print(assistant_response)
  except Exception as e:
    print(f"Error: {str(e)}")


#Main function
def main():
  client = OpenAI()
  assistant = assistant_id_string
  thread = create_thread(client)

  while True:
    user_input = input("Enter message here ('quit' to exit): ")
    if user_input.lower() == 'quit':
      break
    add_message(client, thread, user_input)
    create_run(client, thread, assistant)


if __name__ == "__main__":
  main()
