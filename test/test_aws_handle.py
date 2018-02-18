from mylambda import Message, handler
import unittest2


class BT(unittest2.TestCase):
    def setUp(self):
        self.maxDiff =  None # enable full output on diffs for assertions

class test_aws_stuff(BT):
    def test_i_can_import(self):
        r = Message(verbose=True)
        self.assertEqual(r.verbose,True)

