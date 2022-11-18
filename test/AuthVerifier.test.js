const Auth = artifacts.require("AuthVerifier");

require("chai").use(require("chai-as-promised")).should();

contract("AuthVerifier", ([manager, user1, user2, user3]) => {
  let auth;

  before(async () => {
    auth = await Auth.new();
    await auth.addVerifier(true,true,false,{ from: user2 });
    
  });

  describe("Interacting with verifiers", async () => {
    

    it("Add new verifier succefully", async () => {
      await auth.addVerifier(true,true,false,{ from: user1 });
      let result = await auth.getVerifierExist({ from: user1 })
      
      assert.equal(
        result,
        true,
        "Added new verifier"
      );

    });

    it("Reject duplicate creations", async () => {
        await auth.addVerifier({ from: user2 }).should.be.rejected;
    });

    it("Send verifier not exist", async () => {
        const result = await auth.getVerifierExist({ from: user3 });
        assert.equal(
            result,
            false,
            "Added new verifier"
          );
    });


    it("get account creation verifiables", async () => {
      let result = await auth.isAccountCreationVerifiable(user2);
      assert.equal(
        result,
        true,
        "Account creation verifibale"
      );
  });

  it("get bank loan verifiables", async () => {
    let result = await auth.isBankLaonVerifiable(user2);
    assert.equal(
      result,
      true,
      "Account creation verifibale"
    );});

    it("get card request verifiables", async () => {
      let result = await auth.isCardRequestVerifiable(user2);
      assert.equal(
        result,
        false,
        "Account creation verifibale"
      );
});

it("update services", async () => {
  await auth.updateServices(false, true, true, {from:user2});
  let result = await auth.isAccountCreationVerifiable(user2);
  assert.equal(
    result,
    false,
    "account creation updated successfully"
  );

  result = await auth.isBankLaonVerifiable(user2);
    assert.equal(
      result,
      true,
      "bank loan remains same"
    );

    result = await auth.isCardRequestVerifiable(user2);
    assert.equal(
      result,
      true,
      "card request updated successfully"
    );
});

   
  });
});
