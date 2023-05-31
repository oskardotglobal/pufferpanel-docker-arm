"""
This script can generate all build actions for workflows.
Just change the arch to what you need & change the variants to the names
to include all <arch>/<Variant>.dockerfile. Make sure the dockerfiles names 
are lowercase with the first letter being uppercase.
"""


arch = "arm64"
variants = [ x.lower() for x in ["nodejs"] ]

for x in variants:
    txt = """
      - name: Build %s
        id: build_image_%s
        uses: redhat-actions/buildah-build@v2
        with:
          image: ${{ env.IMAGE_NAME }}
          tags: %s-%s
          context: ./%s
          platforms: linux/%s
          containerfiles: |
            arm64/%s.dockerfile


      - name: Push %s to GHCR
        uses: redhat-actions/push-to-registry@v2
        id: push_image_%s
        with:
          image: ${{ steps.build_image_%s.outputs.image }}
          tags: ${{ steps.build_image_%s.outputs.tags }}
          registry: ${{ env.IMAGE_REGISTRY }}
          username: ${{ env.REGISTRY_USER }}
          password: ${{ env.REGISTRY_PASSWORD }}
    """ % (x, x, arch, x, arch, arch, x.title(), x, x, x, x)

    print(txt)