import java.util.Comparator;

import retrieval.Message;

public class CompareMessageByReadAndTime implements Comparator<Message> {

   @Override
   public int compare(Message m1, Message m2) {
      int read_status = (int)(m1.read - m2.read);
      if (read_status == 0) return -Long.signum(m1.timeSent - m2.timeSent);
      return read_status;
   }

}
